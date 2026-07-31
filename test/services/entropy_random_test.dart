import 'package:flutter_test/flutter_test.dart';
import '../../lib/services/entropy_random.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EntropyRandom Tests', () {
    test('Singleton ensures same instance', () {
      final instance1 = EntropyRandom();
      final instance2 = EntropyRandom();
      expect(identical(instance1, instance2), isTrue);
    });

    test('nextInt generates value within bounds', () {
      final random = EntropyRandom();
      final value = random.nextInt(10);
      expect(value, greaterThanOrEqualTo(0));
      expect(value, lessThan(10));
    });

    test('nextUniqueInts generates requested number of unique values', () {
      final random = EntropyRandom();
      const count = 5;
      const max = 10;
      final values = random.nextUniqueInts(count, max);

      expect(values.length, count);
      // Verify uniqueness
      expect(values.toSet().length, count);
      // Verify bounds
      for (final value in values) {
        expect(value, greaterThanOrEqualTo(0));
        expect(value, lessThan(max));
      }
    });

    test('nextUniqueInts throws error if count > max', () {
      final random = EntropyRandom();
      expect(
        () => random.nextUniqueInts(10, 5),
        throwsArgumentError,
      );
    });

    test('fortuneScore returns value between 0 and 100', () {
      final random = EntropyRandom();
      final score = random.fortuneScore;
      expect(score, greaterThanOrEqualTo(0));
      expect(score, lessThanOrEqualTo(100));
    });

    test('quickDraw returns specified number of cards', () {
      final random = EntropyRandom();
      final cards = random.quickDraw(cardCount: 3, deckSize: 78);
      expect(cards.length, 3);
      expect(cards.toSet().length, 3);
      for (final card in cards) {
        expect(card, greaterThanOrEqualTo(0));
        expect(card, lessThan(78));
      }
    });

    // Note: We skip testing startCollecting/stopCollecting and drawTarotCards
    // as mocking sensors_plus top-level stream functions requires significant
    // architectural changes (e.g., dependency injection for the stream wrappers),
    // and the fallback time entropy works well for unit tests.
  });
}
