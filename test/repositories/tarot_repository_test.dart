import 'package:flutter_test/flutter_test.dart';
import '../../lib/repositories/tarot_repository.dart';
import '../../lib/models/tarot_card.dart';
import '../../lib/data/tarot_deck.dart';

void main() {
  group('TarotRepository.generateInterpretation', () {
    test('generates correct interpretation for pastPresentFuture spread with upright cards', () {
      final draws = [
        TarotDraw(
          card: tarotDeck[0], // The Fool
          position: TarotPosition.upright,
          positionName: 'Past',
        ),
        TarotDraw(
          card: tarotDeck[1], // The Magician
          position: TarotPosition.upright,
          positionName: 'Present',
        ),
        TarotDraw(
          card: tarotDeck[2], // The High Priestess
          position: TarotPosition.upright,
          positionName: 'Future',
        ),
      ];

      final result = TarotRepository.generateInterpretation(draws, TarotSpreadType.pastPresentFuture);

      expect(result, contains('## Past, Present & Future'));
      expect(result, contains('This three-card spread reveals the trajectory of your inquiry:'));
      expect(result, contains('**Past:** The Fool'));
      expect(result, contains('> ${tarotDeck[0].meaningUpright}'));
      expect(result, contains('**Present:** The Magician'));
      expect(result, contains('> ${tarotDeck[1].meaningUpright}'));
      expect(result, contains('**Future:** The High Priestess'));
      expect(result, contains('> ${tarotDeck[2].meaningUpright}'));
      expect(result, contains('---'));
      expect(result, contains('**Guidance:**'));
      expect(result, contains(tarotDeck[0].description));
      expect(result, isNot(contains('*Reversed*')));
    });

    test('generates correct interpretation for celticCross spread with mixed positions', () {
      final draws = List.generate(10, (index) {
        return TarotDraw(
          card: tarotDeck[index],
          position: index % 2 == 0 ? TarotPosition.upright : TarotPosition.reversed,
          positionName: TarotSpreadType.celticCross.defaultPositions[index],
        );
      });

      final result = TarotRepository.generateInterpretation(draws, TarotSpreadType.celticCross);

      expect(result, contains('## Celtic Cross'));
      expect(result, contains('This comprehensive spread explores all aspects of your situation:'));

      for (int i = 0; i < 10; i++) {
        expect(result, contains('**${TarotSpreadType.celticCross.defaultPositions[i]}:** ${tarotDeck[i].displayName}'));
        if (i % 2 != 0) {
          expect(result, contains('*Reversed*'));
          expect(result, contains('> ${tarotDeck[i].meaningReversed}'));
        } else {
          expect(result, contains('> ${tarotDeck[i].meaningUpright}'));
        }
      }
      expect(result, contains('---'));
      expect(result, contains('**Guidance:**'));
      expect(result, contains(tarotDeck[0].description));
    });

    test('generates correct interpretation for relationship spread with reversed cards', () {
      final draws = List.generate(7, (index) {
        return TarotDraw(
          card: tarotDeck[index + 10],
          position: TarotPosition.reversed,
          positionName: TarotSpreadType.relationship.defaultPositions[index],
        );
      });

      final result = TarotRepository.generateInterpretation(draws, TarotSpreadType.relationship);

      expect(result, contains('## Relationship Spread'));
      expect(result, contains('This spread illuminates the dynamics between you and another:'));

      for (int i = 0; i < 7; i++) {
        expect(result, contains('**${TarotSpreadType.relationship.defaultPositions[i]}:** ${tarotDeck[i + 10].displayName}'));
        expect(result, contains('*Reversed*'));
        expect(result, contains('> ${tarotDeck[i + 10].meaningReversed}'));
      }
      expect(result, contains('---'));
      expect(result, contains('**Guidance:**'));
      expect(result, contains(tarotDeck[10].description));
    });
  });
}
