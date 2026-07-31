import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../lib/database/database_helper.dart';
import '../lib/models/user_profile.dart';

void main() {
  late DatabaseHelper databaseHelper;

  setUpAll(() {
    // Initialize FFI for tests
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    databaseHelper = DatabaseHelper.instance;
    await databaseHelper.initInMemoryDbForTesting();
  });

  tearDown(() async {
    await databaseHelper.close();
  });

  group('DatabaseHelper UserProfile Tests', () {
    test('insertUserProfile successfully inserts and returns the same id', () async {
      // Arrange
      final profile = UserProfile(
        name: 'John Doe',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '12:00 PM',
        birthLocation: 'New York, USA',
        latitude: 40.7128,
        longitude: -74.0060,
      );

      // Act
      final resultId = await databaseHelper.insertUserProfile(profile);

      // Assert
      expect(resultId, profile.id);

      final savedProfile = await databaseHelper.getUserProfile(resultId);
      expect(savedProfile, isNotNull);
      expect(savedProfile!.id, profile.id);
      expect(savedProfile.name, 'John Doe');
      expect(savedProfile.birthLocation, 'New York, USA');
      expect(savedProfile.latitude, 40.7128);
      expect(savedProfile.longitude, -74.0060);
    });

    test('insertUserProfile handles optional latitude and longitude missing', () async {
      // Arrange
      final profile = UserProfile(
        name: 'Jane Smith',
        birthDate: DateTime(1985, 5, 15),
        birthTime: '06:30 AM',
        birthLocation: 'London, UK',
        // latitude and longitude omitted
      );

      // Act
      final resultId = await databaseHelper.insertUserProfile(profile);

      // Assert
      expect(resultId, profile.id);

      final savedProfile = await databaseHelper.getUserProfile(resultId);
      expect(savedProfile, isNotNull);
      expect(savedProfile!.id, profile.id);
      expect(savedProfile.name, 'Jane Smith');
      expect(savedProfile.latitude, isNull);
      expect(savedProfile.longitude, isNull);
    });
  });
}
