import 'dart:math' as math;
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

/// A random number generator that uses device sensors (accelerometer/gyroscope)
/// combined with current time to generate entropy for tarot card draws.
/// This makes the card drawing feel more physical and "magical".
class EntropyRandom {
  static final EntropyRandom _instance = EntropyRandom._internal();
  factory EntropyRandom() => _instance;
  EntropyRandom._internal();

  final List<double> _sensorData = [];
  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroSubscription;
  bool _isCollecting = false;

  /// Start collecting sensor data for entropy
  void startCollecting() {
    if (_isCollecting) return;
    _isCollecting = true;
    _sensorData.clear();

    // Collect accelerometer data
    _accelSubscription = accelerometerEventStream().listen((event) {
      _sensorData.add(event.x);
      _sensorData.add(event.y);
      _sensorData.add(event.z);

      // Keep only last 100 readings to prevent memory issues
      if (_sensorData.length > 300) {
        _sensorData.removeRange(0, 3);
      }
    });

    // Collect gyroscope data
    _gyroSubscription = gyroscopeEventStream().listen((event) {
      _sensorData.add(event.x);
      _sensorData.add(event.y);
      _sensorData.add(event.z);

      if (_sensorData.length > 300) {
        _sensorData.removeRange(0, 3);
      }
    });
  }

  /// Stop collecting sensor data
  void stopCollecting() {
    _isCollecting = false;
    _accelSubscription?.cancel();
    _gyroSubscription?.cancel();
    _accelSubscription = null;
    _gyroSubscription = null;
  }

  /// Generate a random number using sensor entropy + time
  /// Returns a value between 0 (inclusive) and max (exclusive)
  int nextInt(int max) {
    // Combine multiple entropy sources
    final timeEntropy = _getTimeEntropy();
    final sensorEntropy = _getSensorEntropy();
    final mixedEntropy = _mixEntropy(timeEntropy, sensorEntropy);

    // Create random from mixed entropy
    final random = math.Random(mixedEntropy);
    return random.nextInt(max);
  }

  /// Generate multiple unique random indices
  /// Useful for drawing cards without replacement
  List<int> nextUniqueInts(int count, int max) {
    if (count > max) {
      throw ArgumentError('Count cannot be greater than max');
    }

    final result = <int>{};
    final timeEntropy = _getTimeEntropy();
    var sensorEntropy = _getSensorEntropy();

    while (result.length < count) {
      final mixedEntropy = _mixEntropy(
        timeEntropy + result.length,
        sensorEntropy,
      );
      final random = math.Random(mixedEntropy);
      final value = random.nextInt(max);

      result.add(value);

      // Mix in more sensor data for next iteration
      sensorEntropy = _mixEntropy(sensorEntropy, timeEntropy + value);
    }

    return result.toList();
  }

  /// Get entropy from current time (nanoseconds + microseconds)
  int _getTimeEntropy() {
    final now = DateTime.now();
    return now.millisecondsSinceEpoch + now.microsecond;
  }

  /// Get entropy from collected sensor data
  int _getSensorEntropy() {
    if (_sensorData.isEmpty) {
      // Fallback to time-based entropy if no sensor data
      return _getTimeEntropy();
    }

    // Combine sensor readings into a single hash-like value
    double sum = 0;
    for (int i = 0; i < _sensorData.length; i++) {
      // Weight recent readings more heavily
      final weight = (i + 1) / _sensorData.length;
      sum += _sensorData[i] * weight;
    }

    // Convert to int, handling both positive and negative values
    return (sum * 1000000).toInt().abs();
  }

  /// Mix two entropy sources using a simple hash combination
  int _mixEntropy(int a, int b) {
    // Based on boost::hash_combine
    return a ^ (b + 0x9e3779b9 + (a << 6) + (a >> 2));
  }

  /// Collect entropy for a specified duration then stop
  /// Returns a Future that completes after the duration
  Future<void> collectFor(Duration duration) async {
    startCollecting();
    await Future.delayed(duration);
    stopCollecting();
  }

  /// Shake detection - returns true if device was shaken
  /// Can be used to trigger card draws
  Stream<bool> get shakeEvents {
    return accelerometerEventStream()
        .map((event) {
          // Calculate magnitude of acceleration
          final magnitude = math.sqrt(
            event.x * event.x + event.y * event.y + event.z * event.z,
          );

          // Shake detected if magnitude exceeds threshold (roughly 2x gravity)
          return magnitude > 20;
        })
        .where((isShaking) => isShaking);
  }

  /// Get a "fortune score" based on current entropy
  /// Returns 0-100, can be used for fun UI elements
  int get fortuneScore {
    final entropy = _getSensorEntropy();
    return (entropy % 101).abs();
  }
}

/// Extension methods for easier card drawing
extension TarotEntropy on EntropyRandom {
  /// Draw tarot cards using sensor entropy
  /// Returns list of card indices
  Future<List<int>> drawTarotCards({
    required int cardCount,
    required int deckSize,
    Duration collectDuration = const Duration(seconds: 2),
  }) async {
    await collectFor(collectDuration);
    return nextUniqueInts(cardCount, deckSize);
  }

  /// Quick draw using current entropy without waiting
  List<int> quickDraw({required int cardCount, required int deckSize}) {
    return nextUniqueInts(cardCount, deckSize);
  }
}
