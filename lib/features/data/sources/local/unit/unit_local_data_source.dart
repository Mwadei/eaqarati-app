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
  Future<int> deleteUnit(int id);
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
  Future<int> deleteUnit(int id) {
    // TODO: implement deleteUnit
    throw UnimplementedError();
  }

  @override
  Future<List<UnitsModel>> getAllUnits() {
    // TODO: implement getAllUnits
    throw UnimplementedError();
  }

  @override
  Future<UnitsModel> getUnitById(int unitId) {
    // TODO: implement getUnitById
    throw UnimplementedError();
  }

  @override
  Future<List<UnitsModel>> getUnitsByPropertyId(int propertyId) {
    // TODO: implement getUnitsByPropertyId
    throw UnimplementedError();
  }

  @override
  Future<int> updateUnit(UnitsModel unit) {
    // TODO: implement updateUnit
    throw UnimplementedError();
  }
}
