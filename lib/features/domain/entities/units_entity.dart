import 'package:equatable/equatable.dart';
import 'package:eaqarati_app/core/utils/enum.dart';

class UnitsEntity extends Equatable {
  final int? unitId;
  final int propertyId;
  final String unitNumber;
  final String? description;
  final UnitStatus status;
  final double? defaultRentAmount;
  final DateTime createdAt;

  const UnitsEntity({
    this.unitId,
    required this.propertyId,
    required this.unitNumber,
    this.description,
    this.status = UnitStatus.vacant, // default status
    this.defaultRentAmount,
    required this.createdAt,
  });

  @override
  List<Object?> get props {
    return [
      unitId,
      propertyId,
      unitNumber,
      description,
      status,
      defaultRentAmount,
      createdAt,
    ];
  }

  String get statusString => status.toString().split('.').last;

  static UnitStatus statusFormString(String status) {
    return UnitStatus.values.firstWhere(
      (element) => element.toString().split('.').last == status,
      orElse: () => UnitStatus.vacant, // Default if not found
    );
  }
}
