import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../lib/providers/app_provider.dart';
import '../../lib/database/database_helper.dart';
import '../../lib/models/user_profile.dart';

class FakeDatabaseHelper extends Fake implements DatabaseHelper {
  @override
  Future<UserProfile?> getDefaultUserProfile() async {
    throw Exception('Database connection failed');
  }
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('AppProvider', () {
    test('initialize sets error when database throws exception', () async {
      final fakeDb = FakeDatabaseHelper();
      final appProvider = AppProvider(db: fakeDb);

      await appProvider.initialize();

      expect(appProvider.error, isNotNull);
      expect(appProvider.error, contains('Database connection failed'));
      expect(appProvider.isLoading, isFalse);
    });
  });
}
