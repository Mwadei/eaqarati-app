import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:eaqarati_app/features/data/sources/local/database_helper.dart';
import 'package:eaqarati_app/features/domain/entities/lease_entity.dart';

class LeaseModel extends LeaseEntity {
  const LeaseModel({
    super.leaseId,
    required super.unitId,
    required super.tenantId,
    required super.startDate,
    required super.endDate,
    required super.rentAmount,
    required super.paymentFrequencyType,
    super.paymentFrequencyValue,
    super.depositAmount,
    super.notes,
    super.isActive,
    required super.createdAt,
  });

  factory LeaseModel.fromMap(Map<String, dynamic> map) {
    return LeaseModel(
      leaseId: map[DatabaseHelper.colLeaseId] as int?,
      unitId: map[DatabaseHelper.colLeaseUnitId] as int,
      tenantId: map[DatabaseHelper.colLeaseTenantId] as int,
      startDate: DateTime.parse(
        map[DatabaseHelper.colLeaseStartDate] as String,
      ),
      endDate: DateTime.parse(map[DatabaseHelper.colLeaseEndDate] as String),
      rentAmount: map[DatabaseHelper.colLeaseRentAmount] as double,
      paymentFrequencyType: PaymentFrequencyTypeExtension.fromString(
        map[DatabaseHelper.colLeasePaymentFrequencyType] as String?,
      ),
      paymentFrequencyValue:
          map[DatabaseHelper.colLeasePaymentFrequencyValue] as int?,
      depositAmount:
          (map[DatabaseHelper.colLeaseDepositAmount] as num?)?.toDouble() ??
          0.0,
      notes: map[DatabaseHelper.colLeaseNotes] as String?,
      isActive: (map[DatabaseHelper.colLeaseIsActive] as int? ?? 1) == 1,
      createdAt: DateTime.parse(
        map[DatabaseHelper.colLeaseCreatedAt] as String,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (leaseId != null) DatabaseHelper.colLeaseId: leaseId,
      DatabaseHelper.colLeaseUnitId: unitId,
      DatabaseHelper.colLeaseTenantId: tenantId,
      DatabaseHelper.colLeaseStartDate: startDate.toIso8601String(),
      DatabaseHelper.colLeaseEndDate: endDate.toIso8601String(),
      DatabaseHelper.colLeaseRentAmount: rentAmount,
      DatabaseHelper.colLeasePaymentFrequencyType: paymentFrequencyType.value,
      DatabaseHelper.colLeasePaymentFrequencyValue: paymentFrequencyValue,
      DatabaseHelper.colLeaseDepositAmount: depositAmount,
      DatabaseHelper.colLeaseNotes: notes,
      DatabaseHelper.colLeaseIsActive: isActive ? 1 : 0,
      DatabaseHelper.colLeaseCreatedAt: createdAt.toIso8601String(),
    };
  }

  LeaseModel copyWith({
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
    return LeaseModel(
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
}
