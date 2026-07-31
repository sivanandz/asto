import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/tarot_card.dart';
import '../../lib/data/tarot_deck.dart'; // Import to resolve tarotDeck in TarotDraw.fromMap

void main() {
  group('TarotReading.fromMap', () {
    test('successfully parses a valid map', () {
      final validMap = {
        'id': '12345',
        'createdAt': '2023-10-27T10:00:00.000Z',
        'question': 'What is my future?',
        'draws': [
          {
            'cardId': 0, // Ensure this card exists in tarotDeck (e.g. The Fool)
            'position': 'upright',
            'positionName': 'Past',
          }
        ],
        'interpretation': 'It looks good.',
      };

      final reading = TarotReading.fromMap(validMap);

      expect(reading.id, '12345');
      expect(reading.question, 'What is my future?');
      expect(reading.draws.length, 1);
      expect(reading.draws.first.card.id, 0);
      expect(reading.draws.first.position, TarotPosition.upright);
      expect(reading.draws.first.positionName, 'Past');
      expect(reading.interpretation, 'It looks good.');
    });

    test('throws FormatException when a required field is missing', () {
      final mapMissingDraws = {
        'id': '12345',
        'createdAt': '2023-10-27T10:00:00.000Z',
        'question': 'What is my future?',
        // 'draws' is missing
        'interpretation': 'It looks good.',
      };

      expect(
        () => TarotReading.fromMap(mapMissingDraws),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when a field has an invalid type', () {
      final mapInvalidDate = {
        'id': '12345',
        'createdAt': 'invalid-date-string',
        'question': 'What is my future?',
        'draws': [],
        'interpretation': 'It looks good.',
      };

      expect(
        () => TarotReading.fromMap(mapInvalidDate),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when draws list contains invalid item', () {
      final mapInvalidDraw = {
        'id': '12345',
        'createdAt': '2023-10-27T10:00:00.000Z',
        'question': 'What is my future?',
        'draws': [
          {
            // Missing position, etc.
            'cardId': 0,
          }
        ],
        'interpretation': 'It looks good.',
      };

      expect(
        () => TarotReading.fromMap(mapInvalidDraw),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
