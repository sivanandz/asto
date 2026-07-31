import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../lib/database/database_helper.dart';
import '../../lib/models/user_profile.dart';
import '../../lib/models/birth_chart.dart';
import '../../lib/models/planet_position.dart';
import '../../lib/models/tarot_card.dart';
import '../../lib/data/tarot_deck.dart';

void main() {
  // Initialize sqflite ffi for desktop/testing
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('DatabaseHelper CRUD Tests', () {
    late DatabaseHelper dbHelper;

    setUp(() async {
      dbHelper = DatabaseHelper.instance;
      // We clear the database by closing and deleting the file or just use in memory if we modify helper.
      // But currently it's hardcoded to 'obsidian_astro.db'. We can delete it.
      final dbPath = await getDatabasesPath();
      final path = '$dbPath/obsidian_astro.db';
      await databaseFactory.deleteDatabase(path);
    });

    tearDown(() async {
      await dbHelper.close();
      DatabaseHelper.resetDatabaseForTest();
    });

    test('UserProfile CRUD operations', () async {
      // Create
      final profile = UserProfile(
        name: 'Test User',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '12:00',
        birthLocation: 'Test City',
        latitude: 0.0,
        longitude: 0.0,
      );

      final id = await dbHelper.insertUserProfile(profile);
      expect(id, isNotEmpty);

      // Read
      final fetchedProfile = await dbHelper.getUserProfile(id);
      expect(fetchedProfile, isNotNull);
      expect(fetchedProfile!.name, 'Test User');

      // Update
      final updatedProfile = fetchedProfile.copyWith(name: 'Updated User');
      await dbHelper.updateUserProfile(updatedProfile);

      final refetchedProfile = await dbHelper.getUserProfile(id);
      expect(refetchedProfile!.name, 'Updated User');

      // Delete
      await dbHelper.deleteUserProfile(id);
      final deletedProfile = await dbHelper.getUserProfile(id);
      expect(deletedProfile, isNull);
    });

    test('BirthChart CRUD operations', () async {
      // First create a user since BirthChart has a foreign key constraint
      final profile = UserProfile(
        name: 'Test User',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '12:00',
        birthLocation: 'Test City',
      );
      final userId = await dbHelper.insertUserProfile(profile);

      // Create Chart
      final chart = BirthChart(
        userId: userId,
        type: ChartType.western,
        positions: [
          PlanetPosition(
            planet: PlanetType.sun,
            sign: ZodiacSign.aries,
            degree: 15.5,
            house: 1,
          )
        ],
      );

      final chartId = await dbHelper.insertBirthChart(chart);
      expect(chartId, isNotEmpty);

      // Read Chart
      final fetchedChart = await dbHelper.getBirthChart(chartId);
      expect(fetchedChart, isNotNull);
      expect(fetchedChart!.userId, userId);
      expect(fetchedChart.type, ChartType.western);
      expect(fetchedChart.positions.length, 1);
      expect(fetchedChart.positions.first.planet, PlanetType.sun);

      // Get Charts by User
      final chartsByUser = await dbHelper.getBirthChartsByUser(userId);
      expect(chartsByUser.length, 1);

      // Delete Chart
      await dbHelper.deleteBirthChart(chartId);
      final deletedChart = await dbHelper.getBirthChart(chartId);
      expect(deletedChart, isNull);
    });

    test('TarotReading CRUD operations', () async {
      // Create Reading
      final reading = TarotReading(
        question: 'Will I pass the test?',
        draws: [
          TarotDraw(
            card: tarotDeck.first,
            position: TarotPosition.upright,
            positionName: 'Past',
          )
        ],
        interpretation: 'Yes.',
      );

      final readingId = await dbHelper.insertTarotReading(reading);
      expect(readingId, isNotEmpty);

      // Read Reading
      final fetchedReading = await dbHelper.getTarotReading(readingId);
      expect(fetchedReading, isNotNull);
      expect(fetchedReading!.question, 'Will I pass the test?');
      expect(fetchedReading.interpretation, 'Yes.');
      expect(fetchedReading.draws.length, 1);
      expect(fetchedReading.draws.first.positionName, 'Past');

      // Get All Readings
      final allReadings = await dbHelper.getAllTarotReadings();
      expect(allReadings.length, 1);

      // Delete Reading
      await dbHelper.deleteTarotReading(readingId);
      final deletedReading = await dbHelper.getTarotReading(readingId);
      expect(deletedReading, isNull);
    });
  });
}
