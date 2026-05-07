import 'package:flutter_test/flutter_test.dart';
import '../../lib/services/entropy_random.dart';

void main() {
  group('EntropyRandom', () {
    late EntropyRandom entropyRandom;

    setUp(() {
      entropyRandom = EntropyRandom();
    });

    test('nextInt returns value within range', () {
      const max = 10;
      for (int i = 0; i < 100; i++) {
        final result = entropyRandom.nextInt(max);
        expect(result, greaterThanOrEqualTo(0));
        expect(result, lessThan(max));
      }
    });

    test('nextUniqueInts returns unique values within range', () {
      const count = 5;
      const max = 10;
      final result = entropyRandom.nextUniqueInts(count, max);

      expect(result.length, equals(count));
      expect(result.toSet().length, equals(count));
      for (final value in result) {
        expect(value, greaterThanOrEqualTo(0));
        expect(value, lessThan(max));
      }
    });

    test('nextUniqueInts throws error if count > max', () {
      expect(() => entropyRandom.nextUniqueInts(11, 10), throwsArgumentError);
    });

    test('fortuneScore returns value between 0 and 100', () {
      final score = entropyRandom.fortuneScore;
      expect(score, greaterThanOrEqualTo(0));
      expect(score, <= 100);
    });
  });
}
