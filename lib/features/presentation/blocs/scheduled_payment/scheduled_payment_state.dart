part of 'scheduled_payment_bloc.dart';

sealed class ScheduledPaymentState extends Equatable {
  const ScheduledPaymentState();
  
  @override
  List<Object> get props => [];
}

final class ScheduledPaymentInitial extends ScheduledPaymentState {}
