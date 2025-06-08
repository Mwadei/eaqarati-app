import 'package:eaqarati_app/features/data/models/tenant_model.dart';
import 'package:eaqarati_app/features/data/sources/local/database_helper.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

abstract class TenantLocalDataSource {
  Future<TenantModel> getTenantById(int tenantId);
  Future<List<TenantModel>> getAllTenants();
  Future<int> addTenant(TenantModel tenant);
  Future<int> updateTenant(TenantModel tenant);
  Future<int> deleteTenant(int tenantId);
}

class TenantLocalDataSourceImpl implements TenantLocalDataSource {
  final DatabaseHelper databaseHelper;
  final Logger _logger = Logger();

  TenantLocalDataSourceImpl({required this.databaseHelper});
  @override
  Future<int> addTenant(TenantModel tenant) async {
    final db = await databaseHelper.database;
    final tenantModel = tenant.toMap();

    tenantModel.removeWhere(
      (key, value) => key == DatabaseHelper.colTenantId && value == null,
    );

    _logger.i("Adding tenant: ${tenantModel.toString()}");

    try {
      return await db.insert(
        DatabaseHelper.tableTenants,
        tenantModel,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (e) {
      _logger.e("Error adding tenant: $e via TenantLocalDataSourceImpl");
      rethrow;
    }
  }

  @override
  Future<int> deleteTenant(int tenantId) async {
    final db = await databaseHelper.database;
    final columnId = DatabaseHelper.colTenantId;
    _logger.i("Deleting tenant with id: $tenantId");

    try {
      return await db.delete(
        DatabaseHelper.tableTenants,
        where: '{$columnId} = ? ',
        whereArgs: [tenantId],
      );
    } catch (e) {
      _logger.e(
        "Error deleting tenant $tenantId: $e  via TenantLocalDataSourceImpl",
      );
      rethrow;
    }
  }

  @override
  Future<List<TenantModel>> getAllTenants() async {
    final db = await databaseHelper.database;
    _logger.i("Getting all tenants");

    try {
      final List<Map<String, dynamic>> tenants = await db.query(
        DatabaseHelper.tableTenants,
      );
      if (tenants.isEmpty) {
        return [];
      }

      return tenants.map((e) => TenantModel.fromMap(e)).toList();
    } catch (e) {
      _logger.e("Error getting all tenants: $e via TenantLocalDataSourceImpl");
      rethrow;
    }
  }

  @override
  Future<TenantModel> getTenantById(int tenantId) async {
    final db = await databaseHelper.database;
    final columnId = DatabaseHelper.colTenantId;

    _logger.i("Getting tenant by id: $tenantId");

    try {
      final List<Map<String, Object?>> tenant = await db.query(
        DatabaseHelper.tableTenants,
        where: '{$columnId} = ?',
        whereArgs: [tenantId],
        limit: 1,
      );

      if (tenant.isNotEmpty) {
        return TenantModel.fromMap(tenant.first);
      } else {
        _logger.w(
          'Tenant with ID $tenantId not found via TenantLocalDataSourceImpl',
        );
        throw Exception(
          'Tenant with ID $tenantId not found via TenantLocalDataSourceImpl',
        );
      }
    } catch (e) {
      _logger.e(
        "Error getting tenant by id $tenantId: $e via TenantLocalDataSourceImpl",
      );
      rethrow;
    }
  }

  @override
  Future<int> updateTenant(TenantModel tenant) async {
    final db = await databaseHelper.database;
    final columnId = DatabaseHelper.colTenantId;

    _logger.i("Updating tenant: ${tenant.toMap().toString()}");

    try {
      return await db.update(
        DatabaseHelper.tableTenants,
        tenant.toMap(),
        where: '{$columnId} = ? ',
        whereArgs: [tenant.tenantId],
      );
    } catch (e) {
      _logger.e(
        "Error updating tenant ${tenant.tenantId}: $e via TenantLocalDataSourceImpl",
      );
      rethrow;
    }
  }
}
