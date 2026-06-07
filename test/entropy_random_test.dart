import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/services/entropy_random.dart';

void main() {
  group('EntropyRandom', () {
    late EntropyRandom entropyRandom;

    setUp(() {
      entropyRandom = EntropyRandom();
    });

    test('nextInt generates numbers within correct bounds', () {
      final max = 10;
      for (int i = 0; i < 100; i++) {
        final result = entropyRandom.nextInt(max);
        expect(result, greaterThanOrEqualTo(0));
        expect(result, lessThan(max));
      }
    });

    test('nextUniqueInts generates expected number of unique values', () {
      final count = 5;
      final max = 10;
      final result = entropyRandom.nextUniqueInts(count, max);

      expect(result.length, equals(count));
      expect(result.toSet().length, equals(count)); // all elements are unique

      for (final value in result) {
        expect(value, greaterThanOrEqualTo(0));
        expect(value, lessThan(max));
      }
    });

    test('nextUniqueInts throws if count > max', () {
      final count = 10;
      final max = 5;

      expect(
        () => entropyRandom.nextUniqueInts(count, max),
        throwsArgumentError,
      );
    });
  });
}
