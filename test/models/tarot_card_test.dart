import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/tarot_card.dart';
import '../../lib/data/tarot_deck.dart';

void main() {
  group('TarotReading.fromMap', () {
    test('successfully parses a valid map', () {
      final validMap = {
        'id': 'test_id',
        'createdAt': '2023-10-27T10:00:00.000Z',
        'question': 'What is my future?',
        'draws': [
          {
            'cardId': tarotDeck.first.id,
            'position': 'upright',
            'positionName': 'Past',
          }
        ],
        'interpretation': 'A good future.',
      };

      final reading = TarotReading.fromMap(validMap);

      expect(reading.id, 'test_id');
      expect(reading.createdAt, DateTime.parse('2023-10-27T10:00:00.000Z'));
      expect(reading.question, 'What is my future?');
      expect(reading.draws.length, 1);
      expect(reading.draws.first.card.id, tarotDeck.first.id);
      expect(reading.interpretation, 'A good future.');
    });

    test('throws TypeError when a required key is missing', () {
      final missingDrawsMap = {
        'id': 'test_id',
        'createdAt': '2023-10-27T10:00:00.000Z',
        'question': 'What is my future?',
        // 'draws' is missing
      };

      // Since map['draws'] will be null, (null as List) throws a TypeError
      expect(() => TarotReading.fromMap(missingDrawsMap), throwsA(isA<TypeError>()));
    });

    test('throws TypeError when draws is null', () {
      final nullDrawsMap = {
        'id': 'test_id',
        'createdAt': '2023-10-27T10:00:00.000Z',
        'question': 'What is my future?',
        'draws': null,
      };

      // (null as List) throws a TypeError
      expect(() => TarotReading.fromMap(nullDrawsMap), throwsA(isA<TypeError>()));
    });

    test('throws TypeError when draws is wrong type (e.g., String)', () {
      final wrongTypeDrawsMap = {
        'id': 'test_id',
        'createdAt': '2023-10-27T10:00:00.000Z',
        'question': 'What is my future?',
        'draws': 'not a list',
      };

      // ('not a list' as List) throws a TypeError
      expect(() => TarotReading.fromMap(wrongTypeDrawsMap), throwsA(isA<TypeError>()));
    });

    test('throws FormatException when createdAt is malformed date string', () {
       final malformedDateMap = {
        'id': 'test_id',
        'createdAt': 'invalid-date',
        'question': 'What is my future?',
        'draws': [],
      };

      expect(() => TarotReading.fromMap(malformedDateMap), throwsFormatException);
    });

    test('throws TypeError when createdAt is null', () {
       final nullDateMap = {
        'id': 'test_id',
        'createdAt': null, // DateTime.parse requires a non-null string
        'question': 'What is my future?',
        'draws': [],
      };

      expect(() => TarotReading.fromMap(nullDateMap), throwsA(isA<TypeError>()));
    });
  });
}
