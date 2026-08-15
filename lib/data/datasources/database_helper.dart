import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../domain/models/password_entry.dart';

class DatabaseHelper {
  static const _databaseName = "PasswordManager.db";
  static const _databaseVersion = 1;

  static const tablePasswords = 'passwords';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tablePasswords (
        id TEXT PRIMARY KEY,
        service_name TEXT NOT NULL,
        username TEXT NOT NULL,
        encrypted_password TEXT NOT NULL,
        notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  Future<int> insert(PasswordEntry entry) async {
    final db = await database;
    return await db.insert(
      tablePasswords,
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PasswordEntry>> getAllEntries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tablePasswords,
      orderBy: 'service_name ASC',
    );
    return List.generate(maps.length, (i) => PasswordEntry.fromMap(maps[i]));
  }

  Future<List<PasswordEntry>> searchEntries(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tablePasswords,
      where: 'service_name LIKE ? OR username LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'service_name ASC',
    );
    return List.generate(maps.length, (i) => PasswordEntry.fromMap(maps[i]));
  }

  Future<int> update(PasswordEntry entry) async {
    final db = await database;
    return await db.update(
      tablePasswords,
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await database;
    return await db.delete(
      tablePasswords,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
