import 'dart:convert';
import '../data/tarot_deck.dart';

enum TarotSuit {
  majorArcana,
  cups,
  wands,
  swords,
  pentacles,
}

enum TarotPosition {
  upright,
  reversed,
}

class TarotCard {
  final int id;
  final String name;
  final String displayName;
  final TarotSuit suit;
  final int? number;
  final String keywords;
  final String meaningUpright;
  final String meaningReversed;
  final String description;

  const TarotCard({
    required this.id,
    required this.name,
    required this.displayName,
    required this.suit,
    this.number,
    required this.keywords,
    required this.meaningUpright,
    required this.meaningReversed,
    required this.description,
  });

  String get imageAsset => 'assets/tarot/$name.png';

  String get suitSymbol {
    return switch (suit) {
      TarotSuit.majorArcana => '✦',
      TarotSuit.cups => '🏆',
      TarotSuit.wands => '🪄',
      TarotSuit.swords => '⚔️',
      TarotSuit.pentacles => '🪙',
    };
  }

  String get romanNumeral {
    if (number == null) return '';
    const numerals = ['0', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X',
      'XI', 'XII', 'XIII', 'XIV', 'XV', 'XVI', 'XVII', 'XVIII', 'XIX', 'XX', 'XXI'];
    if (number! >= 0 && number! < numerals.length) {
      return numerals[number!];
    }
    return number.toString();
  }
}

class TarotReading {
  final String id;
  final DateTime createdAt;
  final String question;
  final List<TarotDraw> draws;
  final String? interpretation;

  TarotReading({
    String? id,
    DateTime? createdAt,
    required this.question,
    required this.draws,
    this.interpretation,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'question': question,
      'draws': jsonEncode(draws.map((d) => d.toMap()).toList()),
      'interpretation': interpretation,
    };
  }

  factory TarotReading.fromMap(Map<String, dynamic> map) {
    List<dynamic> parsedDraws = [];
    if (map['draws'] is String) {
      parsedDraws = jsonDecode(map['draws']);
    } else if (map['draws'] is List) {
      parsedDraws = map['draws'];
    }

    return TarotReading(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      question: map['question'],
      draws: parsedDraws
          .map((d) => TarotDraw.fromMap(d as Map<String, dynamic>))
          .toList(),
      interpretation: map['interpretation'],
    );
  }
}

class TarotDraw {
  final TarotCard card;
  final TarotPosition position;
  final String positionName;

  const TarotDraw({
    required this.card,
    required this.position,
    required this.positionName,
  });

  String get meaning => position == TarotPosition.upright
      ? card.meaningUpright
      : card.meaningReversed;

  Map<String, dynamic> toMap() {
    return {
      'cardId': card.id,
      'position': position.name,
      'positionName': positionName,
    };
  }

  factory TarotDraw.fromMap(Map<String, dynamic> map) {
    return TarotDraw(
      card: tarotDeck.firstWhere((c) => c.id == map['cardId']),
      position: TarotPosition.values.byName(map['position']),
      positionName: map['positionName'],
    );
  }
}