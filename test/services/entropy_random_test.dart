import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/services/entropy_random.dart';

void main() {
  group('EntropyRandom', () {
    late EntropyRandom entropyRandom;

    setUp(() {
      entropyRandom = EntropyRandom();
    });

    test('nextUniqueInts should throw ArgumentError when count > max', () {
      expect(
        () => entropyRandom.nextUniqueInts(10, 5),
        throwsArgumentError,
      );
    });

    test('nextUniqueInts should return correct number of unique elements', () {
      final count = 5;
      final max = 10;
      final result = entropyRandom.nextUniqueInts(count, max);

      expect(result.length, equals(count));
      expect(result.toSet().length, equals(count));
      for (final value in result) {
        expect(value, greaterThanOrEqualTo(0));
        expect(value, lessThan(max));
      }
    });

    test('nextInt should return value within range', () {
      final max = 10;
      for (var i = 0; i < 100; i++) {
        final result = entropyRandom.nextInt(max);
        expect(result, greaterThanOrEqualTo(0));
        expect(result, lessThan(max));
      }
    });
  });
}
