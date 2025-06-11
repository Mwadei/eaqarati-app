part of 'scheduled_payment_bloc.dart';

sealed class ScheduledPaymentState extends Equatable {
  const ScheduledPaymentState();

  @override
  List<Object?> get props => [];
}

final class ScheduledPaymentInitial extends ScheduledPaymentState {}

class ScheduledPaymentLoading extends ScheduledPaymentState {}

class ScheduledPaymentsLoaded extends ScheduledPaymentState {
  final List<ScheduledPaymentEntity> scheduledPayments;
  const ScheduledPaymentsLoaded(this.scheduledPayments);
  @override
  List<Object?> get props => [scheduledPayments];
}

class ScheduledPaymentLoaded extends ScheduledPaymentState {
  final ScheduledPaymentEntity scheduledPayment;
  const ScheduledPaymentLoaded(this.scheduledPayment);
  @override
  List<Object?> get props => [scheduledPayment];
}

class ScheduledPaymentUpdateSuccess extends ScheduledPaymentState {}

class ScheduledPaymentError extends ScheduledPaymentState {
  final String message;
  const ScheduledPaymentError(this.message);
  @override
  List<Object?> get props => [message];
}
