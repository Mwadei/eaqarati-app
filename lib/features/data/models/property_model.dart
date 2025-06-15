import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:eaqarati_app/features/data/sources/local/database_helper.dart';
import 'package:eaqarati_app/features/domain/entities/property_entity.dart';

class PropertyModel extends PropertyEntity {
  const PropertyModel({
    super.propertyId,
    required super.name,
    super.address,
    required super.type,
    super.notes,
    required super.createdAt,
  });

  factory PropertyModel.fromMap(Map<String, dynamic> map) {
    return PropertyModel(
      propertyId: map[DatabaseHelper.colPropertyId] as int?,
      name: map[DatabaseHelper.colPropertyName] as String,
      address: map[DatabaseHelper.colPropertyAddress] as String,
      type: map[DatabaseHelper.colPropertyType] as PropertyType,
      notes: map[DatabaseHelper.colPropertyNotes] as String,
      createdAt: DateTime.parse(
        map[DatabaseHelper.colPropertyCreatedAt] as String,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (propertyId != null) DatabaseHelper.colPropertyId: propertyId,
      DatabaseHelper.colPropertyName: name,
      DatabaseHelper.colPropertyAddress: address,
      DatabaseHelper.colPropertyType: type,
      DatabaseHelper.colPropertyNotes: notes,
      DatabaseHelper.colPropertyCreatedAt: createdAt.toIso8601String(),
    };
  }

  PropertyModel copyWith({
    int? propertyId,
    String? name,
    String? address,
    PropertyType? type,
    String? notes,
    DateTime? createdAt,
  }) {
    return PropertyModel(
      propertyId: propertyId ?? this.propertyId,
      name: name ?? this.name,
      address: address ?? this.address,
      type: type ?? this.type,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
