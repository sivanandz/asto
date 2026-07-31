import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../lib/database/database_helper.dart';
import '../lib/models/user_profile.dart';
import '../lib/models/birth_chart.dart';
import '../lib/models/tarot_card.dart';
import '../lib/models/planet_position.dart';
import '../lib/data/tarot_deck.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('tarot_readings');
    await db.delete('birth_charts');
    await db.delete('user_profiles');
  });

  group('DatabaseHelper - UserProfile', () {
    test('insert and get UserProfile', () async {
      final profile = UserProfile(
        name: 'Test User',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '12:00',
        birthLocation: 'New York, NY',
      );

      final id = await DatabaseHelper.instance.insertUserProfile(profile);
      expect(id, isNotNull);

      final fetched = await DatabaseHelper.instance.getUserProfile(id);
      expect(fetched, isNotNull);
      expect(fetched!.name, 'Test User');
    });

    test('update UserProfile', () async {
      final profile = UserProfile(
        name: 'Test User',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '12:00',
        birthLocation: 'New York, NY',
      );

      final id = await DatabaseHelper.instance.insertUserProfile(profile);

      final updatedProfile = profile.copyWith(name: 'Updated User');
      await DatabaseHelper.instance.updateUserProfile(updatedProfile);

      final fetched = await DatabaseHelper.instance.getUserProfile(id);
      expect(fetched!.name, 'Updated User');
    });

    test('delete UserProfile', () async {
      final profile = UserProfile(
        name: 'Test User',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '12:00',
        birthLocation: 'New York, NY',
      );

      final id = await DatabaseHelper.instance.insertUserProfile(profile);
      await DatabaseHelper.instance.deleteUserProfile(id);

      final fetched = await DatabaseHelper.instance.getUserProfile(id);
      expect(fetched, isNull);
    });
  });

  group('DatabaseHelper - BirthChart', () {
    test('insert and get BirthChart', () async {
      final profile = UserProfile(
        name: 'Test User',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '12:00',
        birthLocation: 'New York, NY',
      );
      final userId = await DatabaseHelper.instance.insertUserProfile(profile);

      final chart = BirthChart(
        userId: userId,
        type: ChartType.vedicNorthIndian,
        ayanamsa: AyanamsaType.lahiri,
        positions: [
          PlanetPosition(
            planet: PlanetType.sun,
            degree: 15.0,
            sign: ZodiacSign.aries,
            house: 1,
            isRetrograde: false,
          ),
        ],
      );

      final id = await DatabaseHelper.instance.insertBirthChart(chart);
      expect(id, isNotNull);

      final fetched = await DatabaseHelper.instance.getBirthChart(id);
      expect(fetched, isNotNull);
      expect(fetched!.userId, userId);
      expect(fetched.positions.first.planet, PlanetType.sun);
    });

    test('delete BirthChart', () async {
      final profile = UserProfile(
        name: 'Test User',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '12:00',
        birthLocation: 'New York, NY',
      );
      final userId = await DatabaseHelper.instance.insertUserProfile(profile);

      final chart = BirthChart(
        userId: userId,
        type: ChartType.vedicNorthIndian,
        ayanamsa: AyanamsaType.lahiri,
        positions: [],
      );

      final id = await DatabaseHelper.instance.insertBirthChart(chart);
      await DatabaseHelper.instance.deleteBirthChart(id);

      final fetched = await DatabaseHelper.instance.getBirthChart(id);
      expect(fetched, isNull);
    });
  });

  group('DatabaseHelper - TarotReading', () {
    test('insert and get TarotReading', () async {
      final reading = TarotReading(
        question: 'What is my focus for today?',
        draws: [
          TarotDraw(
            card: tarotDeck.first,
            position: TarotPosition.upright,
            positionName: 'Present',
          ),
        ],
        interpretation: 'Test interpretation',
      );

      final id = await DatabaseHelper.instance.insertTarotReading(reading);
      expect(id, isNotNull);

      final fetched = await DatabaseHelper.instance.getTarotReading(id);
      expect(fetched, isNotNull);
      expect(fetched!.question, 'What is my focus for today?');
      expect(fetched.draws.first.positionName, 'Present');
    });

    test('delete TarotReading', () async {
      final reading = TarotReading(
        question: 'What is my focus for today?',
        draws: [],
      );

      final id = await DatabaseHelper.instance.insertTarotReading(reading);
      await DatabaseHelper.instance.deleteTarotReading(id);

      final fetched = await DatabaseHelper.instance.getTarotReading(id);
      expect(fetched, isNull);
    });
  });
}
