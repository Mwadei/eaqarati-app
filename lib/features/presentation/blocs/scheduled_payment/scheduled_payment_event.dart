part of 'scheduled_payment_bloc.dart';

sealed class ScheduledPaymentEvent extends Equatable {
  const ScheduledPaymentEvent();

  @override
  List<Object?> get props => [];
}

class LoadScheduledPaymentsByLeaseId extends ScheduledPaymentEvent {
  final int leaseId;
  const LoadScheduledPaymentsByLeaseId(this.leaseId);
  @override
  List<Object?> get props => [leaseId];
}

class LoadScheduledPaymentDetails extends ScheduledPaymentEvent {
  final int scheduledPaymentId;
  const LoadScheduledPaymentDetails(this.scheduledPaymentId);
  @override
  List<Object?> get props => [scheduledPaymentId];
}

class LoadOverdueScheduledPayments extends ScheduledPaymentEvent {
  final DateTime? currentDate;
  const LoadOverdueScheduledPayments({this.currentDate});
  @override
  List<Object?> get props => [currentDate];
}

class LoadUpcomingScheduledPayments extends ScheduledPaymentEvent {
  final DateTime fromDate;
  final DateTime toDate;

  const LoadUpcomingScheduledPayments({
    required this.fromDate,
    required this.toDate,
  });
  @override
  List<Object?> get props => [fromDate, toDate];
}

class LoadScheduledPaymentsByStatus extends ScheduledPaymentEvent {
  final String status;
  const LoadScheduledPaymentsByStatus(this.status);
  @override
  List<Object?> get props => [status];
}

// Generally, updating scheduled payments happens via RecordPaymentUseCase.
// This event is for direct manipulation if ever needed, use with caution.
class UpdateManuallyScheduledPayment extends ScheduledPaymentEvent {
  final ScheduledPaymentEntity scheduledPayment;
  const UpdateManuallyScheduledPayment(this.scheduledPayment);
  @override
  List<Object?> get props => [scheduledPayment];
}
