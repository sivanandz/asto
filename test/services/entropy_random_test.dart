import 'package:flutter_test/flutter_test.dart';
import '../../lib/services/entropy_random.dart';

void main() {
  group('EntropyRandom', () {
    final entropyRandom = EntropyRandom();

    test('nextInt returns value within range', () {
      final max = 10;
      for (int i = 0; i < 100; i++) {
        final result = entropyRandom.nextInt(max);
        expect(result, isNonNegative);
        expect(result, lessThan(max));
      }
    });

    test('nextUniqueInts returns unique values within range', () {
      final count = 5;
      final max = 10;
      final result = entropyRandom.nextUniqueInts(count, max);

      expect(result.length, count);
      expect(result.toSet().length, count);
      for (final value in result) {
        expect(value, isNonNegative);
        expect(value, lessThan(max));
      }
    });

    test('nextUniqueInts throws if count > max', () {
      expect(() => entropyRandom.nextUniqueInts(11, 10), throwsArgumentError);
    });

    test('fortuneScore returns value between 0 and 100', () {
      final score = entropyRandom.fortuneScore;
      expect(score, greaterThanOrEqualTo(0));
      expect(score, lessThanOrEqualTo(100));
    });
  });
}
