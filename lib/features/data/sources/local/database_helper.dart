import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'eaqarati.db';
  static const _databaseVersion = 1;

  // --- Table Names ---
  static const tableProperties = 'Properties';
  static const tableUnits = 'Units';
  static const tableTenants = 'Tenants';
  static const tableLeases = 'Leases';
  static const tableScheduledPayments = 'ScheduledPayments';
  static const tablePayments = 'Payments';

  // --- Properties Table Columns ---
  static const colPropertyId = 'property_id';
  static const colPropertyName = 'name';
  static const colPropertyAddress = 'address';
  static const colPropertyType = 'type';
  static const colPropertyNotes = 'notes';
  static const colPropertyCreatedAt = 'created_at';

  // --- Units Table Columns ---
  static const colUnitId = 'unit_id';
  static const colUnitPropertyId = 'property_id'; // Foreign key
  static const colUnitNumber = 'unit_number';
  static const colUnitDescription = 'description';
  static const colUnitStatus = 'status';
  static const colUnitDefaultRent = 'default_rent_amount';
  static const colUnitCreatedAt = 'created_at';

  // --- Tenants Table Columns ---
  static const colTenantId = 'tenant_id';
  static const colTenantFullName = 'full_name';
  static const colTenantPhoneNumber = 'phone_number';
  static const colTenantEmail = 'email';
  static const colTenantNationalId = 'national_id';
  static const colTenantNotes = 'notes';
  static const colTenantCreatedAt = 'created_at';

  // --- Leases Table Columns ---
  static const colLeaseId = 'lease_id';
  static const colLeaseUnitId = 'unit_id'; // Foreign Key
  static const colLeaseTenantId = 'tenant_id'; // Foreign Key
  static const colLeaseStartDate = 'start_date';
  static const colLeaseEndDate = 'end_date';
  static const colLeaseRentAmount = 'rent_amount';
  static const colLeasePaymentFrequencyType = 'payment_frequency_type';
  static const colLeasePaymentFrequencyValue = 'payment_frequency_value';
  static const colLeaseDepositAmount = 'deposit_amount';
  static const colLeaseNotes = 'notes';
  static const colLeaseIsActive = 'is_active';
  static const colLeaseCreatedAt = 'created_at';

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
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Properties Table
    await db.execute('''
            Create Table IF NOT EXISTS $tableProperties (
              $colPropertyId INTEGER PRIMARY KEY AUTOINCREMENT,
              $colPropertyName TEXT NOT NULL,
              $colPropertyAddress TEXT,
              $colPropertyType TEXT NOT NULL,
              $colPropertyNotes TEXT,
              $colPropertyCreatedAt TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
            )
          ''');

    // Units Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableUnits (
        $colUnitId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colUnitPropertyId INTEGER NOT NULL,
        $colUnitNumber TEXT NOT NULL,
        $colUnitDescription TEXT,
        $colUnitStatus TEXT NOT NULL,
        $colUnitDefaultRent REAL,
        $colUnitCreatedAt TEXT NOT NULL DEFAULT (datetime('now', 'localtime')),
        FOREIGN KEY ($colUnitPropertyId) REFERENCES $tableProperties ($colPropertyId) ON DELETE CASCADE
      )
    ''');

    // Tenants Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableTenants (
        $colTenantId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colTenantFullName TEXT NOT NULL,
        $colTenantPhoneNumber TEXT,
        $colTenantEmail TEXT,
        $colTenantNationalId TEXT,
        $colTenantNotes TEXT,
        $colTenantCreatedAt TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
      )
    ''');

    // Leases Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableLeases (
        $colLeaseId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colLeaseUnitId INTEGER NOT NULL,
        $colLeaseTenantId INTEGER NOT NULL,
        $colLeaseStartDate TEXT NOT NULL,
        $colLeaseEndDate TEXT NOT NULL,
        $colLeaseRentAmount REAL NOT NULL,
        $colLeasePaymentFrequencyType TEXT NOT NULL,
        $colLeasePaymentFrequencyValue INTEGER,
        $colLeaseDepositAmount REAL DEFAULT 0.0,
        $colLeaseNotes TEXT,
        $colLeaseIsActive INTEGER DEFAULT 1,
        $colLeaseCreatedAt TEXT NOT NULL DEFAULT (datetime('now', 'localtime')),
        FOREIGN KEY ($colLeaseUnitId) REFERENCES $tableUnits ($colUnitId) ON DELETE RESTRICT,
        FOREIGN KEY ($colLeaseTenantId) REFERENCES $tableTenants ($colTenantId) ON DELETE RESTRICT
      )
    ''');
  }
}
