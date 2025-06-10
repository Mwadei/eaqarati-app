import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'scheduled_payment_event.dart';
part 'scheduled_payment_state.dart';

class ScheduledPaymentBloc extends Bloc<ScheduledPaymentEvent, ScheduledPaymentState> {
  ScheduledPaymentBloc() : super(ScheduledPaymentInitial()) {
    on<ScheduledPaymentEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
