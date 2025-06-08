import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:eaqarati_app/features/data/sources/local/database_helper.dart';
import 'package:eaqarati_app/features/domain/entities/units_entity.dart';

class UnitsModel extends UnitsEntity {
  const UnitsModel({
    super.unitId,
    required super.propertyId,
    required super.unitNumber,
    super.description,
    super.status,
    super.defaultRentAmount,
    required super.createdAt,
  });

  factory UnitsModel.fromMap(Map<String, dynamic> map) {
    return UnitsModel(
      unitId: map[DatabaseHelper.colUnitId] as int?,
      propertyId: map[DatabaseHelper.colUnitPropertyId] as int,
      unitNumber: map[DatabaseHelper.colUnitNumber] as String,
      description: map[DatabaseHelper.colUnitDescription] as String?,
      status: UnitsEntity.statusFormString(
        map[DatabaseHelper.colUnitStatus] as String,
      ),
      defaultRentAmount: map[DatabaseHelper.colUnitDefaultRent] as double?,
      createdAt: DateTime.parse(map[DatabaseHelper.colUnitCreatedAt] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (unitId != null) DatabaseHelper.colUnitId: unitId,
      DatabaseHelper.colUnitPropertyId: propertyId,
      DatabaseHelper.colUnitNumber: unitNumber,
      DatabaseHelper.colUnitDescription: description,
      DatabaseHelper.colUnitStatus: statusString,
      DatabaseHelper.colUnitDefaultRent: defaultRentAmount,
      DatabaseHelper.colUnitCreatedAt: createdAt.toIso8601String(),
    };
  }

  UnitsModel copyWith({
    int? unitId,
    int? propertyId,
    String? unitNumber,
    String? description,
    UnitStatus? status,
    double? defaultRentAmount,
    DateTime? createdAt,
  }) {
    return UnitsModel(
      unitId: unitId ?? this.unitId,
      propertyId: propertyId ?? this.propertyId,
      unitNumber: unitNumber ?? this.unitNumber,
      description: description ?? this.description,
      status: status ?? this.status,
      defaultRentAmount: defaultRentAmount ?? this.defaultRentAmount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
