part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class RecordNewPayment extends PaymentEvent {
  final PaymentEntity payment;
  const RecordNewPayment(this.payment);
  @override
  List<Object?> get props => [payment];
}

class LoadPaymentsByLeaseId extends PaymentEvent {
  final int leaseId;
  const LoadPaymentsByLeaseId(this.leaseId);
  @override
  List<Object?> get props => [leaseId];
}

class LoadPaymentsByTenantId extends PaymentEvent {
  final int tenantId;
  const LoadPaymentsByTenantId(this.tenantId);
  @override
  List<Object?> get props => [tenantId];
}

class LoadPaymentsByScheduledPaymentId extends PaymentEvent {
  final int scheduledPaymentId;
  const LoadPaymentsByScheduledPaymentId(this.scheduledPaymentId);
  @override
  List<Object?> get props => [scheduledPaymentId];
}

class LoadPaymentDetailsById extends PaymentEvent {
  final int paymentId;
  const LoadPaymentDetailsById(this.paymentId);
  @override
  List<Object?> get props => [paymentId];
}

class DeleteRecordedPayment extends PaymentEvent {
  final int paymentId;
  const DeleteRecordedPayment(this.paymentId);
  @override
  List<Object?> get props => [paymentId];
}
