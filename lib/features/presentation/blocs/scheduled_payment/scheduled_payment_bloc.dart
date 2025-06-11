import 'package:bloc/bloc.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/scheduled_payment_entity.dart';
import 'package:eaqarati_app/features/domain/usecases/scheduled_payment/get_overdue_scheduled_payments_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/scheduled_payment/get_scheduled_payment_by_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/scheduled_payment/get_scheduled_payment_by_status.dart';
import 'package:eaqarati_app/features/domain/usecases/scheduled_payment/get_scheduled_payments_by_lease_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/scheduled_payment/update_scheduled_payment_use_case.dart';
import 'package:equatable/equatable.dart';

part 'scheduled_payment_event.dart';
part 'scheduled_payment_state.dart';

class ScheduledPaymentBloc
    extends Bloc<ScheduledPaymentEvent, ScheduledPaymentState> {
  final GetScheduledPaymentsByLeaseIdUseCase
  getScheduledPaymentsByLeaseIdUseCase;
  final GetScheduledPaymentByIdUseCase getScheduledPaymentByIdUseCase;
  final GetOverdueScheduledPaymentsUseCase getOverdueScheduledPaymentsUseCase;
  final GetScheduledPaymentByStatus getScheduledPaymentByStatusUseCase;
  final UpdateScheduledPaymentUseCase updateScheduledPaymentUseCase;

  ScheduledPaymentBloc({
    required this.getScheduledPaymentsByLeaseIdUseCase,
    required this.getScheduledPaymentByIdUseCase,
    required this.getOverdueScheduledPaymentsUseCase,
    required this.getScheduledPaymentByStatusUseCase,
    required this.updateScheduledPaymentUseCase,
  }) : super(ScheduledPaymentInitial()) {
    on<LoadScheduledPaymentsByLeaseId>(_onLoadScheduledPaymentsByLeaseId);
    on<LoadScheduledPaymentDetails>(_onLoadScheduledPaymentDetails);
    on<LoadOverdueScheduledPayments>(_onLoadOverdueScheduledPayments);
    on<LoadScheduledPaymentsByStatus>(_onLoadScheduledPaymentsByStatus);
    on<UpdateManuallyScheduledPayment>(_onUpdateManuallyScheduledPayment);
  }

  Future<void> _onLoadScheduledPaymentsByLeaseId(
    LoadScheduledPaymentsByLeaseId event,
    Emitter<ScheduledPaymentState> emit,
  ) async {
    emit(ScheduledPaymentLoading());
    final result = await getScheduledPaymentsByLeaseIdUseCase(event.leaseId);
    result.fold(
      (failure) => emit(ScheduledPaymentError(_mapFailureToMessage(failure))),
      (payments) => emit(ScheduledPaymentsLoaded(payments)),
    );
  }

  Future<void> _onLoadScheduledPaymentDetails(
    LoadScheduledPaymentDetails event,
    Emitter<ScheduledPaymentState> emit,
  ) async {
    emit(ScheduledPaymentLoading());
    final result = await getScheduledPaymentByIdUseCase(
      event.scheduledPaymentId,
    );
    result.fold(
      (failure) => emit(ScheduledPaymentError(_mapFailureToMessage(failure))),
      (payment) => emit(ScheduledPaymentLoaded(payment)),
    );
  }

  Future<void> _onLoadOverdueScheduledPayments(
    LoadOverdueScheduledPayments event,
    Emitter<ScheduledPaymentState> emit,
  ) async {
    emit(ScheduledPaymentLoading());
    final result = await getOverdueScheduledPaymentsUseCase(
      currentDate: event.currentDate,
    );
    result.fold(
      (failure) => emit(ScheduledPaymentError(_mapFailureToMessage(failure))),
      (payments) => emit(ScheduledPaymentsLoaded(payments)),
    );
  }

  Future<void> _onLoadScheduledPaymentsByStatus(
    LoadScheduledPaymentsByStatus event,
    Emitter<ScheduledPaymentState> emit,
  ) async {
    emit(ScheduledPaymentLoading());
    final result = await getScheduledPaymentByStatusUseCase(event.status);
    result.fold(
      (failure) => emit(ScheduledPaymentError(_mapFailureToMessage(failure))),
      (payments) => emit(ScheduledPaymentsLoaded(payments)),
    );
  }

  Future<void> _onUpdateManuallyScheduledPayment(
    UpdateManuallyScheduledPayment event,
    Emitter<ScheduledPaymentState> emit,
  ) async {
    emit(ScheduledPaymentLoading());
    final result = await updateScheduledPaymentUseCase(event.scheduledPayment);
    result.fold(
      (failure) => emit(ScheduledPaymentError(_mapFailureToMessage(failure))),
      (_) => emit(ScheduledPaymentUpdateSuccess()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return 'Server Error: ${failure.message}';
      case const (DatabaseFailure):
        return 'Database Error: ${failure.message}';
      case const (NotFoundFailure):
        return 'Not Found: ${failure.message}';
      case const (ValidationFailure):
        return 'Validation Error: ${failure.message}';
      default:
        return 'Unexpected error: ${failure.message}';
    }
  }
}
