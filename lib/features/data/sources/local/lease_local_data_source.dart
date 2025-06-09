import 'package:eaqarati_app/features/data/models/lease_model.dart';
import 'package:eaqarati_app/features/data/sources/local/database_helper.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

abstract class LeaseLocalDataSource {
  Future<LeaseModel?> getLeaseById(int leaseId);
  Future<List<LeaseModel>> getAllLeases();
  Future<List<LeaseModel>> getLeasesByUnitId(int unitId);
  Future<List<LeaseModel>> getLeasesByTenantId(int tenantId);
  Future<List<LeaseModel>> getActiveLeases();
  Future<int> addLease(LeaseModel lease, {Transaction? txn});
  Future<int> updateLease(LeaseModel lease, {Transaction? txn});
  Future<int> deleteLease(int leaseId, {Transaction? txn});
}

class LeaseLocalDataSourceImpl implements LeaseLocalDataSource {
  final DatabaseHelper databaseHelper;
  final Logger _logger = Logger();

  LeaseLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<int> addLease(LeaseModel lease, {Transaction? txn}) async {
    final dbOrTxn = txn ?? await databaseHelper.database;
    Map<String, dynamic> leaseMap = lease.toMap();
    leaseMap.removeWhere(
      (key, value) => key == DatabaseHelper.colLeaseId && value == null,
    );
    _logger.i("Adding lease: ${leaseMap.toString()}");
    try {
      return await dbOrTxn.insert(
        DatabaseHelper.tableLeases,
        leaseMap,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (e) {
      _logger.e("Error adding lease: $e");
      rethrow;
    }
  }

  @override
  Future<int> deleteLease(int leaseId, {Transaction? txn}) async {
    final dbOrTxn = txn ?? await databaseHelper.database;
    _logger.i("Deleting lease with id: $leaseId");
    try {
      return await dbOrTxn.delete(
        DatabaseHelper.tableLeases,
        where: '${DatabaseHelper.colLeaseId} = ?',
        whereArgs: [leaseId],
      );
    } catch (e) {
      _logger.e("Error deleting lease $leaseId: $e");
      rethrow;
    }
  }

  @override
  Future<List<LeaseModel>> getAllLeases() async {
    final db = await databaseHelper.database;
    _logger.i("Getting all leases");
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.tableLeases,
      );
      return maps.map((map) => LeaseModel.fromMap(map)).toList();
    } catch (e) {
      _logger.e("Error getting all leases: $e");
      rethrow;
    }
  }

  @override
  Future<LeaseModel?> getLeaseById(int leaseId) async {
    final db = await databaseHelper.database;
    _logger.i("Getting lease by id: $leaseId");
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.tableLeases,
        where: '${DatabaseHelper.colLeaseId} = ?',
        whereArgs: [leaseId],
        limit: 1,
      );
      if (maps.isNotEmpty) {
        return LeaseModel.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      _logger.e("Error getting lease by id $leaseId: $e");
      rethrow;
    }
  }

  @override
  Future<int> updateLease(LeaseModel lease, {Transaction? txn}) async {
    final dbOrTxn = await databaseHelper.database;
    _logger.i("Updating lease: ${lease.toMap().toString()}");
    try {
      return await dbOrTxn.update(
        DatabaseHelper.tableLeases,
        lease.toMap(),
        where: '${DatabaseHelper.colLeaseId} = ?',
        whereArgs: [lease.leaseId],
      );
    } catch (e) {
      _logger.e("Error updating lease ${lease.leaseId}: $e");
      rethrow;
    }
  }

  @override
  Future<List<LeaseModel>> getLeasesByUnitId(int unitId) async {
    final db = await databaseHelper.database;
    _logger.i("Getting leases for unit id: $unitId");
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.tableLeases,
        where: '${DatabaseHelper.colLeaseUnitId} = ?',
        whereArgs: [unitId],
      );
      return maps.map((map) => LeaseModel.fromMap(map)).toList();
    } catch (e) {
      _logger.e("Error getting leases for unit id $unitId: $e");
      rethrow;
    }
  }

  @override
  Future<List<LeaseModel>> getLeasesByTenantId(int tenantId) async {
    final db = await databaseHelper.database;
    _logger.i("Getting leases for tenant id: $tenantId");
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.tableLeases,
        where: '${DatabaseHelper.colLeaseTenantId} = ?',
        whereArgs: [tenantId],
      );
      return maps.map((map) => LeaseModel.fromMap(map)).toList();
    } catch (e) {
      _logger.e("Error getting leases for tenant id $tenantId: $e");
      rethrow;
    }
  }

  @override
  Future<List<LeaseModel>> getActiveLeases() async {
    final db = await databaseHelper.database;
    _logger.i("Getting active leases");
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.tableLeases,
        where: '${DatabaseHelper.colLeaseIsActive} = ?',
        whereArgs: [1], // 1 for true
      );
      return maps.map((map) => LeaseModel.fromMap(map)).toList();
    } catch (e) {
      _logger.e("Error getting active leases: $e");
      rethrow;
    }
  }
}
