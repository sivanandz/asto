import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

import '../lib/database/database_helper.dart';
import '../lib/models/tarot_card.dart';
import '../lib/data/tarot_deck.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('Benchmark N+1 vs Bulk Delete', () async {
    final dbHelper = DatabaseHelper.instance;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'test_tarot_db.db');

    // Clear old test db if exists
    await deleteDatabase(path);

    // Initialize
    await dbHelper.database;

    // Ensure table exists for direct testing if something is missing
    final db = await dbHelper.database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS tarot_readings (
        id TEXT PRIMARY KEY,
        createdAt TEXT NOT NULL,
        question TEXT NOT NULL,
        draws TEXT NOT NULL,
        interpretation TEXT
      )
    ''');

    Future<void> insertTestRecord(String id) async {
       await db.insert('tarot_readings', {
         'id': id,
         'createdAt': DateTime.now().toIso8601String(),
         'question': 'Test',
         'draws': '[]',
         'interpretation': 'Test'
       });
    }

    // Insert 100 dummy readings for N+1 benchmark
    for (int i = 0; i < 100; i++) {
      await insertTestRecord(const Uuid().v4());
    }

    final readingsForN1 = await db.query('tarot_readings');
    expect(readingsForN1.length, 100);

    final stopwatch1 = Stopwatch()..start();
    for (final reading in readingsForN1) {
      await dbHelper.deleteTarotReading(reading['id'] as String);
    }
    stopwatch1.stop();
    print('N+1 Deletion Time for 100 records: ${stopwatch1.elapsedMilliseconds} ms');

    // Insert 100 dummy readings for Bulk benchmark
    for (int i = 0; i < 100; i++) {
      await insertTestRecord(const Uuid().v4());
    }

    final readingsForBulk = await db.query('tarot_readings');
    expect(readingsForBulk.length, 100);

    final stopwatch2 = Stopwatch()..start();
    await db.delete('tarot_readings'); // Simulate bulk delete
    stopwatch2.stop();
    print('Bulk Deletion Time for 100 records: ${stopwatch2.elapsedMilliseconds} ms');

    await dbHelper.close();
    await deleteDatabase(path);
  });
}
