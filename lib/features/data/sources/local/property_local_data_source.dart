import 'package:eaqarati_app/features/data/models/property_model.dart';
import 'package:eaqarati_app/features/data/sources/local/database_helper.dart';
import 'package:logger/web.dart';
import 'package:sqflite/sqflite.dart';

abstract class PropertyLocalDataSource {
  Future<PropertyModel> getPropertyById(int propertyId);
  Future<List<PropertyModel>> getAllProperties();
  Future<int> addProperty(PropertyModel property);
  Future<int> updateProperty(PropertyModel property);
  Future<int> deleteProperty(int propertyId);
}

class PropertyLocalDataSourceImpl implements PropertyLocalDataSource {
  final DatabaseHelper databaseHelper;

  PropertyLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<int> addProperty(PropertyModel property) async {
    final db = await databaseHelper.database;
    Map<String, dynamic> propertyMap = property.toMap();

    propertyMap.removeWhere(
      (key, value) => key == DatabaseHelper.colPropertyId && value == null,
    );

    return await db.insert(
      DatabaseHelper.tableProperties,
      propertyMap,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  @override
  Future<int> deleteProperty(int propertyId) async {
    final db = await databaseHelper.database;
    final columnId = DatabaseHelper.colPropertyId;

    return await db.delete(
      DatabaseHelper.tableProperties,
      where: '$columnId = ?',
      whereArgs: [propertyId],
    );
  }

  @override
  Future<List<PropertyModel>> getAllProperties() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> properties = await db.query(
      DatabaseHelper.tableProperties,
    );

    if (properties.isEmpty) return [];
    // return List.generate(maps.length, (index) {
    //   return PropertyModel.fromMap(maps[index]);
    // });
    return properties.map((data) => PropertyModel.fromMap(data)).toList();
  }

  @override
  Future<PropertyModel> getPropertyById(int propertyId) async {
    final db = await databaseHelper.database;
    final columnId = DatabaseHelper.colPropertyId;
    final List<Map<String, dynamic>> property = await db.query(
      DatabaseHelper.tableProperties,
      where: '$columnId = ?',
      whereArgs: [propertyId],
      limit: 1,
    );

    if (property.isNotEmpty) {
      return PropertyModel.fromMap(property.first);
    } else {
      Logger().d('Property with ID $propertyId not found');
      throw Exception('Property with ID $propertyId not found');
    }
  }

  @override
  Future<int> updateProperty(PropertyModel property) async {
    final db = await databaseHelper.database;
    final columnId = DatabaseHelper.colPropertyId;

    return await db.update(
      DatabaseHelper.tableProperties,
      property.toMap(),
      where: '$columnId = ?',
      whereArgs: [property.propertyId],
    );
  }
}
