import 'package:eaqarati_app/core/utils/enum.dart';
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
      unitId: map['unit_id'] as int?,
      propertyId: map['property_id'] as int,
      unitNumber: map['unit_number'] as String,
      description: map['description'] as String?,
      status: UnitsEntity.statusFormString(map['status'] as String),
      defaultRentAmount: map['default_rent_amount'] as double?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (unitId != null) 'unit_id': unitId,
      'property_id': propertyId,
      'unit_number': unitNumber,
      'description': description,
      'status': statusString,
      'default_rent_amount': defaultRentAmount,
      'created_at': createdAt.toIso8601String(),
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
