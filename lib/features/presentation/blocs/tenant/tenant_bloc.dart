import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tenant_event.dart';
part 'tenant_state.dart';

class TenantBloc extends Bloc<TenantEvent, TenantState> {
  TenantBloc() : super(TenantInitial()) {
    on<TenantEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
