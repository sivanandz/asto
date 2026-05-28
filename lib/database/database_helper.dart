import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_profile.dart';
import '../models/birth_chart.dart';
import '../models/tarot_card.dart';

class DatabaseHelper {
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
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE settings (
          key TEXT PRIMARY KEY,
          value TEXT NOT NULL
        )
      ''');
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_profiles (
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
    ''');

    await db.execute('''
      CREATE TABLE birth_charts (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        type TEXT NOT NULL,
        ayanamsa TEXT,
        positions TEXT NOT NULL,
        calculatedAt TEXT NOT NULL,
        additionalData TEXT,
        FOREIGN KEY (userId) REFERENCES user_profiles (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE tarot_readings (
        id TEXT PRIMARY KEY,
        createdAt TEXT NOT NULL,
        question TEXT NOT NULL,
        draws TEXT NOT NULL,
        interpretation TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  // Settings CRUD
  Future<void> upsertSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      'settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getSetting(String key) async {
    final db = await database;
    final maps = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (maps.isNotEmpty) {
      return maps.first['value'] as String?;
    }
    return null;
  }

  // User Profile CRUD
  Future<String> insertUserProfile(UserProfile profile) async {
    final db = await database;
    await db.insert('user_profiles', profile.toMap());
    return profile.id;
  }

  Future<UserProfile?> getUserProfile(String id) async {
    final db = await database;
    final maps = await db.query(
      'user_profiles',
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
      'user_profiles',
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
    final maps = await db.query('user_profiles', orderBy: 'createdAt DESC');
    return maps.map((map) => UserProfile.fromMap(map)).toList();
  }

  Future<int> updateUserProfile(UserProfile profile) async {
    final db = await database;
    return await db.update(
      'user_profiles',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  Future<int> deleteUserProfile(String id) async {
    final db = await database;
    return await db.delete(
      'user_profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Birth Chart CRUD
  Future<String> insertBirthChart(BirthChart chart) async {
    final db = await database;
    await db.insert('birth_charts', chart.toMap());
    return chart.id;
  }

  Future<BirthChart?> getBirthChart(String id) async {
    final db = await database;
    final maps = await db.query(
      'birth_charts',
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
      'birth_charts',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'calculatedAt DESC',
    );
    return maps.map((map) => BirthChart.fromMap(map)).toList();
  }

  Future<int> deleteBirthChart(String id) async {
    final db = await database;
    return await db.delete(
      'birth_charts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Tarot Reading CRUD
  Future<String> insertTarotReading(TarotReading reading) async {
    final db = await database;
    await db.insert('tarot_readings', reading.toMap());
    return reading.id;
  }

  Future<List<TarotReading>> getAllTarotReadings() async {
    final db = await database;
    final maps = await db.query(
      'tarot_readings',
      orderBy: 'createdAt DESC',
    );
    return maps.map((map) => TarotReading.fromMap(map)).toList();
  }

  Future<TarotReading?> getTarotReading(String id) async {
    final db = await database;
    final maps = await db.query(
      'tarot_readings',
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
      'tarot_readings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}