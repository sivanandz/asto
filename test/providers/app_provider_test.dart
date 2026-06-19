import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/providers/app_provider.dart';
import 'package:my_app/database/database_helper.dart';
import 'package:my_app/services/entropy_random.dart';
import 'package:my_app/models/user_profile.dart';
import 'package:my_app/models/birth_chart.dart';
import 'package:my_app/models/tarot_card.dart';
import 'package:my_app/data/tarot_deck.dart';
import 'package:my_app/services/astrology_calculator.dart';

class FakeDatabaseHelper extends Fake implements DatabaseHelper {
  UserProfile? defaultProfileToReturn;
  UserProfile? profileToReturn;
  List<BirthChart> chartsToReturn = [];
  List<TarotReading> readingsToReturn = [];
  bool insertCalled = false;
  bool updateCalled = false;
  bool deleteCalled = false;
  bool throwError = false;

  UserProfile? lastInsertedProfile;
  BirthChart? lastInsertedChart;
  TarotReading? lastInsertedReading;

  void reset() {
    defaultProfileToReturn = null;
    profileToReturn = null;
    chartsToReturn = [];
    readingsToReturn = [];
    insertCalled = false;
    updateCalled = false;
    deleteCalled = false;
    throwError = false;
    lastInsertedProfile = null;
    lastInsertedChart = null;
    lastInsertedReading = null;
  }

  @override
  Future<UserProfile?> getDefaultUserProfile() async {
    if (throwError) throw Exception('DB Error');
    return defaultProfileToReturn;
  }

  @override
  Future<List<BirthChart>> getBirthChartsByUser(String userId) async {
    if (throwError) throw Exception('DB Error');
    return chartsToReturn;
  }

  @override
  Future<List<TarotReading>> getAllTarotReadings() async {
    if (throwError) throw Exception('DB Error');
    return readingsToReturn;
  }

  @override
  Future<String> insertUserProfile(UserProfile profile) async {
    if (throwError) throw Exception('DB Error');
    insertCalled = true;
    lastInsertedProfile = profile;
    return profile.id;
  }

  @override
  Future<int> updateUserProfile(UserProfile profile) async {
    if (throwError) throw Exception('DB Error');
    updateCalled = true;
    return 1;
  }

  @override
  Future<UserProfile?> getUserProfile(String id) async {
    if (throwError) throw Exception('DB Error');
    return profileToReturn;
  }

  @override
  Future<int> deleteUserProfile(String id) async {
    if (throwError) throw Exception('DB Error');
    deleteCalled = true;
    return 1;
  }

  @override
  Future<String> insertBirthChart(BirthChart chart) async {
    if (throwError) throw Exception('DB Error');
    insertCalled = true;
    lastInsertedChart = chart;
    return chart.id;
  }

  @override
  Future<String> insertTarotReading(TarotReading reading) async {
    if (throwError) throw Exception('DB Error');
    insertCalled = true;
    lastInsertedReading = reading;
    return reading.id;
  }

  @override
  Future<int> deleteTarotReading(String id) async {
    if (throwError) throw Exception('DB Error');
    deleteCalled = true;
    return 1;
  }
}

class FakeEntropyRandom extends Fake implements EntropyRandom {
  @override
  void startCollecting() {}

  @override
  void stopCollecting() {}

  @override
  int nextInt(int max) {
    return 0; // Return 0 for deterministic testing (always upright)
  }

  @override
  List<int> nextUniqueInts(int count, int max) {
    return List.generate(count, (index) => index);
  }
}

void main() {
  group('AppProvider Tests', () {
    late AppProvider provider;
    late FakeDatabaseHelper fakeDb;
    late FakeEntropyRandom fakeEntropy;

    setUp(() {
      fakeDb = FakeDatabaseHelper();
      fakeEntropy = FakeEntropyRandom();
      provider = AppProvider(db: fakeDb, entropyRandom: fakeEntropy);
    });

    test('initialize loads default user, chart, and tarot readings', () async {
      final profile = UserProfile(
        id: '1',
        name: 'Test User',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '12:00',
        birthLocation: 'Test City',
        latitude: 0,
        longitude: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final chart = AstrologyCalculator.calculateChart(profile, type: ChartType.western);
      final reading = TarotReading(
        id: '1',
        createdAt: DateTime.now(),
        question: 'Test',
        draws: [],
        interpretation: 'Test Interpretation'
      );

      fakeDb.defaultProfileToReturn = profile;
      fakeDb.chartsToReturn = [chart];
      fakeDb.readingsToReturn = [reading];

      await provider.initialize();

      expect(provider.currentUser, equals(profile));
      expect(provider.currentChart, equals(chart));
      expect(provider.tarotReadings, equals([reading]));
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
    });

    test('initialize handles DB error', () async {
      fakeDb.throwError = true;
      await provider.initialize();

      expect(provider.error, equals('Exception: DB Error'));
      expect(provider.isLoading, isFalse);
    });

    test('createUserProfile inserts user and generates chart', () async {
      final profile = UserProfile(
        id: '1',
        name: 'New User',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '12:00',
        birthLocation: 'Test City',
        latitude: 0,
        longitude: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await provider.createUserProfile(profile);

      expect(fakeDb.insertCalled, isTrue);
      expect(fakeDb.lastInsertedProfile, equals(profile));
      expect(provider.currentUser, equals(profile));
      expect(provider.currentChart, isNotNull);
      expect(fakeDb.lastInsertedChart, isNotNull);
    });

    test('updateUserProfile updates user and regenerates chart', () async {
      final profile = UserProfile(
        id: '1',
        name: 'Updated User',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '12:00',
        birthLocation: 'Test City',
        latitude: 0,
        longitude: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await provider.updateUserProfile(profile);

      expect(fakeDb.updateCalled, isTrue);
      expect(provider.currentUser, equals(profile));
      expect(provider.currentChart, isNotNull);
      expect(fakeDb.lastInsertedChart, isNotNull);
    });

    test('loadUserProfile loads user and chart', () async {
      final profile = UserProfile(
        id: '1',
        name: 'Loaded User',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '12:00',
        birthLocation: 'Test City',
        latitude: 0,
        longitude: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final chart = AstrologyCalculator.calculateChart(profile, type: ChartType.western);

      fakeDb.profileToReturn = profile;
      fakeDb.chartsToReturn = [chart];

      await provider.loadUserProfile('1');

      expect(provider.currentUser, equals(profile));
      expect(provider.currentChart, equals(chart));
    });

    test('deleteUserProfile deletes user and clears state', () async {
      final profile = UserProfile(
        id: '1',
        name: 'User to Delete',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '12:00',
        birthLocation: 'Test City',
        latitude: 0,
        longitude: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      fakeDb.profileToReturn = profile;
      await provider.loadUserProfile('1'); // Set current user

      await provider.deleteUserProfile('1');

      expect(fakeDb.deleteCalled, isTrue);
      expect(provider.currentUser, isNull);
      expect(provider.currentChart, isNull);
    });

    test('generateVedicChart generates vedic chart', () async {
      final profile = UserProfile(
        id: '1',
        name: 'Vedic User',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '12:00',
        birthLocation: 'Test City',
        latitude: 0,
        longitude: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      fakeDb.profileToReturn = profile;
      await provider.loadUserProfile('1');

      await provider.generateVedicChart(AyanamsaType.lahiri);

      expect(provider.currentChart, isNotNull);
      expect(provider.currentChart!.type, equals(ChartType.vedicNorthIndian));
    });

    test('drawTarotCards creates reading with deterministic fake entropy', () async {
      // Because fakeEntropy returns [0, 1, 2], cards should be 0th, 1st, 2nd
      await provider.drawTarotCards('My Question', cardCount: 3);

      expect(fakeDb.insertCalled, isTrue);
      expect(provider.tarotReadings.length, equals(1));

      final reading = provider.tarotReadings.first;
      expect(reading.question, equals('My Question'));
      expect(reading.draws.length, equals(3));

      // Since fake returns 0 for isReversed (which means 0 == 0 -> true -> reversed)
      // wait, nextInt(2) == 0 is reversed. Fake returns 0, so all should be reversed.
      expect(reading.draws[0].position, equals(TarotPosition.reversed));
      expect(reading.draws[0].positionName, equals('Past'));
      expect(reading.draws[0].card.id, equals(tarotDeck[0].id));
    });

    test('deleteTarotReading deletes reading from db and state', () async {
      final reading = TarotReading(
        id: 'reading-123',
        createdAt: DateTime.now(),
        question: 'Test',
        draws: [],
        interpretation: 'Test Interpretation'
      );
      fakeDb.readingsToReturn = [reading];
      await provider.initialize();

      expect(provider.tarotReadings.length, equals(1));

      await provider.deleteTarotReading('reading-123');

      expect(fakeDb.deleteCalled, isTrue);
      expect(provider.tarotReadings.isEmpty, isTrue);
    });

    test('clearError resets error state', () {
      provider.initialize(); // fakeDb doesn't error by default
      fakeDb.throwError = true;
      provider.initialize().then((_) {
        expect(provider.error, isNotNull);
        provider.clearError();
        expect(provider.error, isNull);
      });
    });
  });
}
