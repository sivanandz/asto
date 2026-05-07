import 'package:flutter_test/flutter_test.dart';
import '../../lib/providers/app_provider.dart';
import '../../lib/models/tarot_card.dart';

void main() {
  group('AppProvider', () {
    test('generateInterpretation with empty draws returns empty string', () {
      final appProvider = AppProvider();

      final result = appProvider.generateInterpretation([]);

      expect(result, '');
    });

    test('generateInterpretation with draws returns formatted string', () {
      final appProvider = AppProvider();

      final card = TarotCard(
        id: 0,
        name: 'the_fool',
        displayName: 'The Fool',
        suit: TarotSuit.majorArcana,
        number: 0,
        keywords: 'New beginnings',
        meaningUpright: 'Spontaneity',
        meaningReversed: 'Recklessness',
        description: 'A new journey',
      );

      final draws = [
        TarotDraw(
          card: card,
          position: TarotPosition.upright,
          positionName: 'Past',
        ),
      ];

      final result = appProvider.generateInterpretation(draws);

      expect(result.contains('Your cards reveal a journey of transformation.'), isTrue);
      expect(result.contains('Past: The Fool'), isTrue);
      expect(result.contains('Spontaneity'), isTrue);
      expect(result.contains('Recklessness'), isFalse);
    });
  });
}
