import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:equatable/equatable.dart';

class FinancialStatementEntry extends Equatable {
  final String propertyName;
  final String unitNumber;
  final String? tenantName;
  final DateTime periodStartDate;
  final DateTime periodEndDate;
  final double amountDue;
  final double amountPaidSoFar;
  final ScheduledPaymentStatus status;
  final int? leaseId;
  final int? tenantId;

  const FinancialStatementEntry({
    required this.propertyName,
    required this.unitNumber,
    this.tenantName,
    required this.periodStartDate,
    required this.periodEndDate,
    required this.amountDue,
    required this.amountPaidSoFar,
    required this.status,
    this.leaseId,
    this.tenantId,
  });

  double get remainingAmount => amountDue - amountPaidSoFar;
  bool get isFullyPaid =>
      status == ScheduledPaymentStatus.paid || amountPaidSoFar >= amountDue;
  bool get isPartiallyPaid =>
      status == ScheduledPaymentStatus.partiallyPaid &&
      amountPaidSoFar < amountDue &&
      amountPaidSoFar > 0;

  @override
  List<Object?> get props => [
    unitNumber,
    tenantName,
    periodStartDate,
    periodEndDate,
    amountDue,
    amountPaidSoFar,
    status,
    leaseId,
    tenantId,
  ];
}
