import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:eaqarati_app/features/data/sources/local/database_helper.dart';
import 'package:eaqarati_app/features/domain/entities/scheduled_payment_entity.dart';

class ScheduledPaymentModel extends ScheduledPaymentEntity {
  const ScheduledPaymentModel({
    super.scheduledPaymentId,
    required super.leaseId,
    required super.dueDate,
    required super.amountDue,
    required super.periodStartDate,
    required super.periodEndDate,
    super.status,
    super.amountPaidSoFar,
    required super.createdAt,
  });

  factory ScheduledPaymentModel.fromMap(Map<String, dynamic> map) {
    return ScheduledPaymentModel(
      scheduledPaymentId: map[DatabaseHelper.colScheduledPaymentId] as int?,
      leaseId: map[DatabaseHelper.colScheduledPaymentLeaseId] as int,
      dueDate: DateTime.parse(
        map[DatabaseHelper.colScheduledPaymentDueDate] as String,
      ),
      amountDue: map[DatabaseHelper.colScheduledPaymentAmountDue] as double,
      periodStartDate: DateTime.parse(
        map[DatabaseHelper.colScheduledPaymentPeriodStartDate] as String,
      ),
      periodEndDate: DateTime.parse(
        map[DatabaseHelper.colScheduledPaymentPeriodEndDate] as String,
      ),
      status: ScheduledPaymentStatusExtension.fromString(
        map[DatabaseHelper.colScheduledPaymentStatus] as String?,
      ),
      amountPaidSoFar:
          (map[DatabaseHelper.colScheduledPaymentAmountPaidSoFar] as num?)
              ?.toDouble() ??
          0.0,
      createdAt: DateTime.parse(
        map[DatabaseHelper.colScheduledPaymentCreatedAt] as String,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (scheduledPaymentId != null)
        DatabaseHelper.colScheduledPaymentId: scheduledPaymentId,
      DatabaseHelper.colScheduledPaymentLeaseId: leaseId,
      DatabaseHelper.colScheduledPaymentDueDate: dueDate.toIso8601String(),
      DatabaseHelper.colScheduledPaymentAmountDue: amountDue,
      DatabaseHelper.colScheduledPaymentPeriodStartDate:
          periodStartDate.toIso8601String(),
      DatabaseHelper.colScheduledPaymentPeriodEndDate:
          periodEndDate.toIso8601String(),
      DatabaseHelper.colScheduledPaymentStatus: status.value,
      DatabaseHelper.colScheduledPaymentAmountPaidSoFar: amountPaidSoFar,
      DatabaseHelper.colScheduledPaymentCreatedAt: createdAt.toIso8601String(),
    };
  }

  ScheduledPaymentModel copyWith({
    int? scheduledPaymentId,
    int? leaseId,
    DateTime? dueDate,
    double? amountDue,
    DateTime? periodStartDate,
    DateTime? periodEndDate,
    ScheduledPaymentStatus? status,
    double? amountPaidSoFar,
    DateTime? createdAt,
  }) {
    return ScheduledPaymentModel(
      scheduledPaymentId: scheduledPaymentId ?? this.scheduledPaymentId,
      leaseId: leaseId ?? this.leaseId,
      dueDate: dueDate ?? this.dueDate,
      amountDue: amountDue ?? this.amountDue,
      periodStartDate: periodStartDate ?? this.periodStartDate,
      periodEndDate: periodEndDate ?? this.periodEndDate,
      status: status ?? this.status,
      amountPaidSoFar: amountPaidSoFar ?? this.amountPaidSoFar,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
