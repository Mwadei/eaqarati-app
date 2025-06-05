import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'eaqarati.db';
  static const _databaseVersion = 1;

  // --- Table Names ---
  static const tableProperties = 'Properties';
  // Add other table names here later (Units, Tenants, Leases, etc.)

  // --- Properties Table Columns ---
  static const colPropertyId = 'property_id';
  static const colPropertyName = 'name';
  static const colPropertyAddress = 'address';
  static const colPropertyType = 'type';
  static const colPropertyNotes = 'notes';
  static const colPropertyCreatedAt = 'created_at';

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    final _documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(_documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    return await db.execute('''
            Create Table $tableProperties (
              $colPropertyId INTEGER PRIMARY KEY AUTOINCREMENT,
              $colPropertyName TEXT NOT NULL,
              $colPropertyAddress TEXT,
              $colPropertyType TEXT NOT NULL,
              $colPropertyNotes TEXT,
              $colPropertyCreatedAt TEXT NOT NULL
            )
          ''');
  }
}
