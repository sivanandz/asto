import '../database/database_helper.dart';
import '../models/tarot_card.dart';
import '../data/tarot_deck.dart';
import '../services/entropy_random.dart';

class TarotRepository {
  final DatabaseHelper _db;
  final EntropyRandom _entropyRandom = EntropyRandom();

  TarotRepository(this._db);

  Future<TarotReading> createReading(
    String question, {
    List<String>? positions,
    TarotSpreadType? spreadType,
  }) async {
    final spread = spreadType ?? TarotSpreadType.pastPresentFuture;
    final drawCount = spread.cardCount;
    final positionNames = positions ?? spread.defaultPositions;

    // Use sensor entropy + time to draw cards
    final cardIndices = await _entropyRandom.drawTarotCards(
      cardCount: drawCount,
      deckSize: tarotDeck.length,
      collectDuration: const Duration(seconds: 2),
    );

    final draws = <TarotDraw>[];
    
    for (int i = 0; i < cardIndices.length; i++) {
      final card = tarotDeck[cardIndices[i]];
      
      // Use entropy for upright/reversed
      final isReversed = _entropyRandom.nextInt(2) == 0;
      final position = isReversed
          ? TarotPosition.reversed
          : TarotPosition.upright;

      draws.add(TarotDraw(
        card: card,
        position: position,
        positionName: positionNames[i % positionNames.length],
      ));
    }

    final reading = TarotReading(
      question: question,
      draws: draws,
      interpretation: _generateInterpretation(draws, spread),
    );

    await _db.insertTarotReading(reading);
    return reading;
  }

  /// Quick draw without sensor collection (uses cached entropy)
  Future<TarotReading> quickReading(
    String question, {
    List<String>? positions,
    TarotSpreadType? spreadType,
  }) async {
    final spread = spreadType ?? TarotSpreadType.pastPresentFuture;
    final drawCount = spread.cardCount;
    final positionNames = positions ?? spread.defaultPositions;

    final cardIndices = _entropyRandom.quickDraw(
      cardCount: drawCount,
      deckSize: tarotDeck.length,
    );

    final draws = <TarotDraw>[];
    
    for (int i = 0; i < cardIndices.length; i++) {
      final card = tarotDeck[cardIndices[i]];
      final isReversed = _entropyRandom.nextInt(2) == 0;
      final position = isReversed
          ? TarotPosition.reversed
          : TarotPosition.upright;

      draws.add(TarotDraw(
        card: card,
        position: position,
        positionName: positionNames[i % positionNames.length],
      ));
    }

    final reading = TarotReading(
      question: question,
      draws: draws,
      interpretation: _generateInterpretation(draws, spread),
    );

    await _db.insertTarotReading(reading);
    return reading;
  }

  /// Get current fortune score from sensor entropy
  int get fortuneScore => _entropyRandom.fortuneScore;

  Future<List<TarotReading>> getAllReadings() async {
    return await _db.getAllTarotReadings();
  }

  Future<TarotReading?> getReading(String id) async {
    return await _db.getTarotReading(id);
  }

  Future<void> deleteReading(String id) async {
    await _db.deleteTarotReading(id);
  }

  String _generateInterpretation(List<TarotDraw> draws, TarotSpreadType spread) {
    final buffer = StringBuffer();
    
    switch (spread) {
      case TarotSpreadType.pastPresentFuture:
        buffer.writeln('## Past, Present & Future');
        buffer.writeln();
        buffer.writeln('This three-card spread reveals the trajectory of your inquiry:');
        break;
      case TarotSpreadType.celticCross:
        buffer.writeln('## Celtic Cross');
        buffer.writeln();
        buffer.writeln('This comprehensive spread explores all aspects of your situation:');
        break;
      case TarotSpreadType.relationship:
        buffer.writeln('## Relationship Spread');
        buffer.writeln();
        buffer.writeln('This spread illuminates the dynamics between you and another:');
        break;
    }
    buffer.writeln();
    
    for (final draw in draws) {
      buffer.writeln('**${draw.positionName}:** ${draw.card.displayName}');
      if (draw.position == TarotPosition.reversed) {
        buffer.writeln('*Reversed*');
      }
      buffer.writeln('> ${draw.meaning}');
      buffer.writeln();
    }
    
    // Add overall guidance
    buffer.writeln('---');
    buffer.writeln();
    buffer.writeln('**Guidance:**');
    buffer.writeln(draws.first.card.description);
    
    return buffer.toString();
  }
}

enum TarotSpreadType {
  pastPresentFuture,
  celticCross,
  relationship,
}

extension TarotSpreadTypeExtension on TarotSpreadType {
  int get cardCount {
    return switch (this) {
      TarotSpreadType.pastPresentFuture => 3,
      TarotSpreadType.celticCross => 10,
      TarotSpreadType.relationship => 7,
    };
  }

  List<String> get defaultPositions {
    return switch (this) {
      TarotSpreadType.pastPresentFuture => ['Past', 'Present', 'Future'],
      TarotSpreadType.celticCross => [
        'Present Situation',
        'Challenge',
        'Foundation',
        'Recent Past',
        'Best Outcome',
        'Near Future',
        'Self',
        'Environment',
        'Hopes/Fears',
        'Final Outcome',
      ],
      TarotSpreadType.relationship => [
        'You',
        'Partner',
        'Relationship',
        'Strengths',
        'Weaknesses',
        'What You Need',
        'Outcome',
      ],
    };
  }

  String get displayName {
    return switch (this) {
      TarotSpreadType.pastPresentFuture => 'Past, Present & Future',
      TarotSpreadType.celticCross => 'Celtic Cross',
      TarotSpreadType.relationship => 'Relationship Spread',
    };
  }
}