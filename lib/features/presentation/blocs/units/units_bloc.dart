import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'units_event.dart';
part 'units_state.dart';

class UnitsBloc extends Bloc<UnitsEvent, UnitsState> {
  UnitsBloc() : super(UnitsInitial()) {
    on<UnitsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
