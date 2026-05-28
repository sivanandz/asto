import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/repositories/tarot_repository.dart';
import 'package:my_app/database/database_helper.dart';
import 'package:my_app/services/entropy_random.dart';
import 'package:my_app/models/tarot_card.dart';

class FakeDatabaseHelper extends Fake implements DatabaseHelper {
  final List<TarotReading> insertedReadings = [];
  bool shouldThrowOnInsert = false;

  @override
  Future<String> insertTarotReading(TarotReading reading) async {
    if (shouldThrowOnInsert) {
      throw Exception('Database insertion failed');
    }
    insertedReadings.add(reading);
    return reading.id;
  }
}

class FakeEntropyRandom extends Fake implements EntropyRandom {
  List<int> mockNextUniqueInts = [];
  int mockNextInt = 0;
  bool wasCollectCalled = false;

  @override
  Future<void> collectFor(Duration duration) async {
    wasCollectCalled = true;
  }

  @override
  List<int> nextUniqueInts(int count, int max) {
    if (mockNextUniqueInts.length >= count) {
      return mockNextUniqueInts.sublist(0, count);
    }
    return List.generate(count, (index) => index);
  }

  @override
  int nextInt(int max) {
    return mockNextInt;
  }

  Future<List<int>> drawTarotCards({
    required int cardCount,
    required int deckSize,
    Duration collectDuration = const Duration(seconds: 2),
  }) async {
    await collectFor(collectDuration);
    return nextUniqueInts(cardCount, deckSize);
  }

  List<int> quickDraw({
    required int cardCount,
    required int deckSize,
  }) {
    return nextUniqueInts(cardCount, deckSize);
  }
}

void main() {
  group('TarotRepository Tests', () {
    late FakeDatabaseHelper fakeDb;
    late FakeEntropyRandom fakeEntropy;
    late TarotRepository repository;

    setUp(() {
      fakeDb = FakeDatabaseHelper();
      fakeEntropy = FakeEntropyRandom();
      repository = TarotRepository(fakeDb, entropyRandom: fakeEntropy);
    });

    test('createReading - happy path with default spread', () async {
      // Setup mock returns: 3 cards
      fakeEntropy.mockNextUniqueInts = [5, 12, 21];

      // In repository: `final isReversed = _entropyRandom.nextInt(2) == 0;`
      // We want all upright for simplicity: make nextInt return 1
      fakeEntropy.mockNextInt = 1;

      final reading = await repository.createReading('What is my future?');

      expect(fakeEntropy.wasCollectCalled, isTrue);
      expect(fakeDb.insertedReadings.length, 1);
      expect(reading.question, 'What is my future?');
      expect(reading.draws.length, 3);

      // Default spread is Past, Present, Future
      expect(reading.draws[0].positionName, 'Past');
      expect(reading.draws[1].positionName, 'Present');
      expect(reading.draws[2].positionName, 'Future');

      // Check all are upright
      for (var draw in reading.draws) {
        expect(draw.position, TarotPosition.upright);
      }
      expect(reading.interpretation, isNotNull);
      expect(reading.interpretation!.contains('Past, Present & Future'), isTrue);
    });

    test('createReading - handles reversed cards', () async {
      fakeEntropy.mockNextUniqueInts = [0, 1, 2];
      fakeEntropy.mockNextInt = 0; // 0 == 0 means reversed

      final reading = await repository.createReading('Reversed cards?');

      for (var draw in reading.draws) {
        expect(draw.position, TarotPosition.reversed);
      }
    });

    test('createReading - Celtic Cross spread', () async {
      fakeEntropy.mockNextUniqueInts = List.generate(10, (i) => i);

      final reading = await repository.createReading('Deep dive', spreadType: TarotSpreadType.celticCross);

      expect(reading.draws.length, 10);
      expect(reading.draws[0].positionName, 'Present Situation');
      expect(reading.draws[9].positionName, 'Final Outcome');
      expect(reading.interpretation!.contains('Celtic Cross'), isTrue);
    });

    test('createReading - throws when database insertion fails', () async {
      fakeDb.shouldThrowOnInsert = true;

      expect(
        () => repository.createReading('Will this fail?'),
        throwsException,
      );
    });

    test('quickReading - happy path without collect delay', () async {
      fakeEntropy.mockNextUniqueInts = [1, 2, 3];
      fakeEntropy.mockNextInt = 1; // upright

      final reading = await repository.quickReading('Quick test');

      expect(fakeEntropy.wasCollectCalled, isFalse); // Should not call collectFor
      expect(fakeDb.insertedReadings.length, 1);
      expect(reading.draws.length, 3);
    });
  });
}
