import 'dart:math';

class EntropyRandom {
  final Random _random = Random();

  void startCollecting() {}
  void stopCollecting() {}

  double nextDouble() {
    return _random.nextDouble();
  }

  int nextInt(int max) {
    return _random.nextInt(max);
  }

  List<int> nextUniqueInts(int count, int max) {
    final Set<int> result = {};
    while (result.length < count) {
      result.add(_random.nextInt(max));
    }
    return result.toList();
  }
}
