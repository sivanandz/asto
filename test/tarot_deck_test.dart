import 'package:flutter_test/flutter_test.dart';
import '../lib/data/tarot_deck.dart';


void main() {
  group('getCardById', () {
    test('returns null for nonexistent ID', () {
      final card = getCardById(-1);
      expect(card, isNull);
    });

    test('returns card for valid ID', () {
      final card = getCardById(0);
      expect(card, isNotNull);
      expect(card!.id, equals(0));
      expect(card.name, equals('the_fool'));
    });
  });
}
