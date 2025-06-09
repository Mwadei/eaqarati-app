import 'package:eaqarati_app/core/utils/enum.dart'; 
import 'package:equatable/equatable.dart';

class ScheduledPaymentEntity extends Equatable {
  final int? scheduledPaymentId;
  final int leaseId;
  final DateTime dueDate;
  final double amountDue;
  final DateTime periodStartDate; 
  final DateTime periodEndDate;  
  final ScheduledPaymentStatus status;
  final double amountPaidSoFar;
  final DateTime createdAt;

  const ScheduledPaymentEntity({
    this.scheduledPaymentId,
    required this.leaseId,
    required this.dueDate,
    required this.amountDue,
    required this.periodStartDate,
    required this.periodEndDate,
    this.status = ScheduledPaymentStatus.pending,
    this.amountPaidSoFar = 0.0,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        scheduledPaymentId,
        leaseId,
        dueDate,
        amountDue,
        periodStartDate,
        periodEndDate,
        status,
        amountPaidSoFar,
        createdAt,
      ];
}