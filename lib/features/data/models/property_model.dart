import 'package:eaqarati_app/features/domain/entities/Property_entity.dart';

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
      propertyId: map['property_id'] as int?,
      name: map['name'] as String,
      address: map['address'] as String,
      type: map['type'] as String,
      notes: map['notes'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (propertyId != null) 'property_id': propertyId,
      'name': name,
      'address': address,
      'type': type,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  PropertyModel copyWith({
    int? propertyId,
    String? name,
    String? address,
    String? type,
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
