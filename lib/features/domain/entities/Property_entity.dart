import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:equatable/equatable.dart';

class PropertyEntity extends Equatable {
  final int? propertyId;
  final String name;
  final String? address;
  final PropertyType type;
  final String? notes;
  final DateTime createdAt;

  const PropertyEntity({
    required this.propertyId,
    required this.name,
    required this.address,
    required this.type,
    required this.notes,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    propertyId,
    name,
    address,
    type,
    notes,
    createdAt,
  ];

  String get typeString => type.toString().split('.').last;

  static PropertyType typeFormString(String status) {
    return PropertyType.values.firstWhere(
      (element) => element.toString().split('.').last == status,
      orElse: () => PropertyType.apartment, // Default if not found
    );
  }
}
