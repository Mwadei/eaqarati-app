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

  LeaseEntity copyWith({
    int? leaseId,
    int? unitId,
    int? tenantId,
    DateTime? startDate,
    DateTime? endDate,
    double? rentAmount,
    PaymentFrequencyType? paymentFrequencyType,
    int? paymentFrequencyValue,
    double? depositAmount,
    String? notes,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return LeaseEntity(
      leaseId: leaseId ?? this.leaseId,
      unitId: unitId ?? this.unitId,
      tenantId: tenantId ?? this.tenantId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      rentAmount: rentAmount ?? this.rentAmount,
      paymentFrequencyType: paymentFrequencyType ?? this.paymentFrequencyType,
      paymentFrequencyValue:
          paymentFrequencyValue ?? this.paymentFrequencyValue,
      depositAmount: depositAmount ?? this.depositAmount,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

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
