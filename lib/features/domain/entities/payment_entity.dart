import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final int? paymentId;
  final int? scheduledPaymentId;
  final int leaseId;
  final int tenantId;
  final DateTime paymentDate;
  final double amountPaid;
  final String? paymentMethod;
  final String? receiptImagePath;
  final String? notes;
  final DateTime createdAt;

  const PaymentEntity({
    this.paymentId,
    this.scheduledPaymentId,
    required this.leaseId,
    required this.tenantId,
    required this.paymentDate,
    required this.amountPaid,
    this.paymentMethod,
    this.receiptImagePath,
    this.notes,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    paymentId,
    scheduledPaymentId,
    leaseId,
    tenantId,
    paymentDate,
    amountPaid,
    paymentMethod,
    receiptImagePath,
    notes,
    createdAt,
  ];
}
