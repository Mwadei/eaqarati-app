import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'lease_event.dart';
part 'lease_state.dart';

class LeaseBloc extends Bloc<LeaseEvent, LeaseState> {
  LeaseBloc() : super(LeaseInitial()) {
    on<LeaseEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
