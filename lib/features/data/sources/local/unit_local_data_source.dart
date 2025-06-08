import 'package:eaqarati_app/features/data/models/units_model.dart';
import 'package:eaqarati_app/features/data/sources/local/database_helper.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

abstract class UnitLocalDataSource {
  Future<UnitsModel> getUnitById(int unitId);
  Future<List<UnitsModel>> getUnitsByPropertyId(int propertyId);
  Future<List<UnitsModel>> getAllUnits();
  Future<int> addUnit(UnitsModel unit);
  Future<int> updateUnit(UnitsModel unit);
  Future<int> deleteUnit(int unitId);
}

class UnitLocalDataSourceImpl implements UnitLocalDataSource {
  final DatabaseHelper databaseHelper;

  UnitLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<int> addUnit(UnitsModel unit) async {
    try {
      final db = await databaseHelper.database;
      Map<String, dynamic> unitMap = unit.toMap();
      unitMap.removeWhere(
        (key, value) => key == DatabaseHelper.colUnitId && value == null,
      );

      return await db.insert(
        DatabaseHelper.tableUnits,
        unitMap,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } catch (e) {
      Logger().e('Failed to insert Unit via UnitLocalDataSourceImpl');
      throw Exception(e.toString());
    }
  }

  @override
  Future<int> deleteUnit(int unitId) async {
    final db = await databaseHelper.database;
    final columnId = DatabaseHelper.colUnitId;
    return await db.delete(
      DatabaseHelper.tableUnits,
      where: '{$columnId} = ? ',
      whereArgs: [unitId],
    );
  }

  @override
  Future<List<UnitsModel>> getAllUnits() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> units = await db.query(
      DatabaseHelper.tableUnits,
    );

    if (units.isEmpty) return [];
    return units.map((e) => UnitsModel.fromMap(e)).toList();
  }

  @override
  Future<UnitsModel> getUnitById(int unitId) async {
    final db = await databaseHelper.database;
    final columnId = DatabaseHelper.colUnitId;
    final List<Map<String, Object?>> unit = await db.query(
      DatabaseHelper.tableUnits,
      where: '{$columnId} = ?',
      whereArgs: [unitId],
      limit: 1,
    );

    if (unit.isNotEmpty) {
      return unit.map((e) => UnitsModel.fromMap(e)).first;
    } else {
      Logger().e('Unit with ID $unitId is not found');
      throw Exception('Unit with ID $unitId is not found');
    }
  }

  @override
  Future<List<UnitsModel>> getUnitsByPropertyId(int propertyId) async {
    final db = await databaseHelper.database;
    final columnId = DatabaseHelper.colUnitPropertyId;
    final List<Map<String, dynamic>> units = await db.query(
      DatabaseHelper.tableUnits,
      where: '{$columnId} = ?',
      whereArgs: [propertyId],
    );

    if (units.isEmpty) {
      Logger().i('There is no units with property ID $propertyId');
      return [];
    } else {
      return units.map((e) => UnitsModel.fromMap(e)).toList();
    }
  }

  @override
  Future<int> updateUnit(UnitsModel unit) async {
    final db = await databaseHelper.database;
    final columnId = DatabaseHelper.colUnitId;

    return db.update(
      DatabaseHelper.tableUnits,
      unit.toMap(),
      where: '{$columnId} = ?',
      whereArgs: [unit.unitId],
    );
  }
}
