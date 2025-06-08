import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:equatable/equatable.dart';

class LeaseEntity extends Equatable {
  final int? leaseId;
  final int unitId;
  final int tenantId;
  final DateTime startDate;
  final DateTime endDate;
  final double rentAmount;
  final PaymentFrequencyType paymentFrequencyType;
  final int?
  paymentFrequencyValue; // e.g., if Custom_Days, value is number of days
  final double depositAmount;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;

  const LeaseEntity({
    this.leaseId,
    required this.unitId,
    required this.tenantId,
    required this.startDate,
    required this.endDate,
    required this.rentAmount,
    required this.paymentFrequencyType,
    this.paymentFrequencyValue,
    this.depositAmount = 0.0,
    this.notes,
    this.isActive = true,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    leaseId,
    unitId,
    tenantId,
    startDate,
    endDate,
    rentAmount,
    paymentFrequencyType,
    paymentFrequencyValue,
    depositAmount,
    notes,
    isActive,
    createdAt,
  ];
}
