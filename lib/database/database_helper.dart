import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_profile.dart';
import '../models/birth_chart.dart';
import '../models/tarot_card.dart';

class DatabaseHelper {
  static const String tableUserProfiles = 'user_profiles';
  static const String tableBirthCharts = 'birth_charts';
  static const String tableTarotReadings = 'tarot_readings';

  static const String _createUserProfilesTable = '''
    CREATE TABLE $tableUserProfiles (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      birthDate TEXT NOT NULL,
      birthTime TEXT NOT NULL,
      birthLocation TEXT NOT NULL,
      latitude REAL,
      longitude REAL,
      createdAt TEXT NOT NULL,
      updatedAt TEXT NOT NULL
    )
  ''';

  static const String _createBirthChartsTable = '''
    CREATE TABLE $tableBirthCharts (
      id TEXT PRIMARY KEY,
      userId TEXT NOT NULL,
      type TEXT NOT NULL,
      ayanamsa TEXT,
      positions TEXT NOT NULL,
      calculatedAt TEXT NOT NULL,
      additionalData TEXT,
      FOREIGN KEY (userId) REFERENCES $tableUserProfiles (id) ON DELETE CASCADE
    )
  ''';

  static const String _createTarotReadingsTable = '''
    CREATE TABLE $tableTarotReadings (
      id TEXT PRIMARY KEY,
      createdAt TEXT NOT NULL,
      question TEXT NOT NULL,
      draws TEXT NOT NULL,
      interpretation TEXT
    )
  ''';

  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('obsidian_astro.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    final batch = db.batch();
    batch.execute(_createUserProfilesTable);
    batch.execute(_createBirthChartsTable);
    batch.execute(_createTarotReadingsTable);
    await batch.commit();
  }

  // User Profile CRUD
  Future<String> insertUserProfile(UserProfile profile) async {
    final db = await database;
    await db.insert(tableUserProfiles, profile.toMap());
    return profile.id;
  }

  Future<UserProfile?> getUserProfile(String id) async {
    final db = await database;
    final maps = await db.query(
      tableUserProfiles,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UserProfile.fromMap(maps.first);
    }
    return null;
  }

  Future<UserProfile?> getDefaultUserProfile() async {
    final db = await database;
    final maps = await db.query(
      tableUserProfiles,
      orderBy: 'createdAt ASC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return UserProfile.fromMap(maps.first);
    }
    return null;
  }

  Future<List<UserProfile>> getAllUserProfiles() async {
    final db = await database;
    final maps = await db.query(tableUserProfiles, orderBy: 'createdAt DESC');
    return maps.map((map) => UserProfile.fromMap(map)).toList();
  }

  Future<int> updateUserProfile(UserProfile profile) async {
    final db = await database;
    return await db.update(
      tableUserProfiles,
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  Future<int> deleteUserProfile(String id) async {
    final db = await database;
    return await db.delete(
      tableUserProfiles,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Birth Chart CRUD
  Future<String> insertBirthChart(BirthChart chart) async {
    final db = await database;
    await db.insert(tableBirthCharts, chart.toMap());
    return chart.id;
  }

  Future<BirthChart?> getBirthChart(String id) async {
    final db = await database;
    final maps = await db.query(
      tableBirthCharts,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return BirthChart.fromMap(maps.first);
    }
    return null;
  }

  Future<List<BirthChart>> getBirthChartsByUser(String userId) async {
    final db = await database;
    final maps = await db.query(
      tableBirthCharts,
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'calculatedAt DESC',
    );
    return maps.map((map) => BirthChart.fromMap(map)).toList();
  }

  Future<int> deleteBirthChart(String id) async {
    final db = await database;
    return await db.delete(
      tableBirthCharts,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Tarot Reading CRUD
  Future<String> insertTarotReading(TarotReading reading) async {
    final db = await database;
    await db.insert(tableTarotReadings, reading.toMap());
    return reading.id;
  }

  Future<List<TarotReading>> getAllTarotReadings() async {
    final db = await database;
    final maps = await db.query(
      tableTarotReadings,
      orderBy: 'createdAt DESC',
    );
    return maps.map((map) => TarotReading.fromMap(map)).toList();
  }

  Future<TarotReading?> getTarotReading(String id) async {
    final db = await database;
    final maps = await db.query(
      tableTarotReadings,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TarotReading.fromMap(maps.first);
    }
    return null;
  }

  Future<int> deleteTarotReading(String id) async {
    final db = await database;
    return await db.delete(
      tableTarotReadings,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}