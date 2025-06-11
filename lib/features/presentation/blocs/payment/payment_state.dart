part of 'payment_bloc.dart';

sealed class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentRecordedSuccess extends PaymentState {
  final int paymentId;
  const PaymentRecordedSuccess(this.paymentId);
  @override
  List<Object?> get props => [paymentId];
}

class PaymentDeletedSuccess extends PaymentState {}

class PaymentsLoaded extends PaymentState {
  final List<PaymentEntity> payments;
  const PaymentsLoaded(this.payments);
  @override
  List<Object?> get props => [payments];
}

class PaymentLoaded extends PaymentState {
  final PaymentEntity payment;
  const PaymentLoaded(this.payment);
  @override
  List<Object?> get props => [payment];
}

class PaymentError extends PaymentState {
  final String message;
  const PaymentError(this.message);
  @override
  List<Object?> get props => [message];
}
