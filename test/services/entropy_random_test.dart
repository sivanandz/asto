import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/services/entropy_random.dart';

void main() {
  group('EntropyRandom', () {
    final entropyRandom = EntropyRandom();

    test('nextInt returns value within range', () {
      final max = 10;
      for (var i = 0; i < 100; i++) {
        final result = entropyRandom.nextInt(max);
        expect(result, greaterThanOrEqualTo(0));
        expect(result, lessThan(max));
      }
    });

    test('nextUniqueInts returns unique values within range', () {
      final count = 5;
      final max = 10;
      for (var i = 0; i < 10; i++) {
        final result = entropyRandom.nextUniqueInts(count, max);
        expect(result.length, equals(count));
        expect(result.toSet().length, equals(count));
        for (final val in result) {
          expect(val, greaterThanOrEqualTo(0));
          expect(val, lessThan(max));
        }
      }
    });

    test('nextUniqueInts throws error if count > max', () {
      expect(() => entropyRandom.nextUniqueInts(11, 10), throwsArgumentError);
    });

    test('fortuneScore returns value between 0 and 100', () {
      final score = entropyRandom.fortuneScore;
      expect(score, greaterThanOrEqualTo(0));
      expect(score, lessThanOrEqualTo(100));
    });
  });
}
