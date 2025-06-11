import 'package:bloc/bloc.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/payment_entity.dart';
import 'package:eaqarati_app/features/domain/usecases/payments/delete_payment_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/payments/get_payment_by_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/payments/get_payments_by_lease_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/payments/get_payments_by_scheduled_payment_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/payments/get_payments_by_tenant_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/payments/record_payment_use_case.dart';
import 'package:equatable/equatable.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final RecordPaymentUseCase recordPaymentUseCase;
  final GetPaymentsByLeaseIdUseCase getPaymentsByLeaseIdUseCase;
  final GetPaymentsByTenantIdUseCase getPaymentsByTenantIdUseCase;
  final GetPaymentsByScheduledPaymentIdUseCase
  getPaymentsByScheduledPaymentIdUseCase;
  final GetPaymentByIdUseCase getPaymentByIdUseCase;
  final DeletePaymentUseCase deletePaymentUseCase;

  PaymentBloc({
    required this.recordPaymentUseCase,
    required this.getPaymentsByLeaseIdUseCase,
    required this.getPaymentsByTenantIdUseCase,
    required this.getPaymentsByScheduledPaymentIdUseCase,
    required this.getPaymentByIdUseCase,
    required this.deletePaymentUseCase,
  }) : super(PaymentInitial()) {
    on<RecordNewPayment>(_onRecordNewPayment);
    on<LoadPaymentsByLeaseId>(_onLoadPaymentsByLeaseId);
    on<LoadPaymentsByTenantId>(_onLoadPaymentsByTenantId);
    on<LoadPaymentsByScheduledPaymentId>(_onLoadPaymentsByScheduledPaymentId);
    on<LoadPaymentDetailsById>(_onLoadPaymentDetailsById);
    on<DeleteRecordedPayment>(_onDeleteRecordedPayment);
  }

  Future<void> _onRecordNewPayment(
    RecordNewPayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await recordPaymentUseCase(event.payment);
    result.fold(
      (failure) => emit(PaymentError(_mapFailureToMessage(failure))),
      (paymentId) => emit(PaymentRecordedSuccess(paymentId)),
    );
  }

  Future<void> _onLoadPaymentsByLeaseId(
    LoadPaymentsByLeaseId event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await getPaymentsByLeaseIdUseCase(event.leaseId);
    result.fold(
      (failure) => emit(PaymentError(_mapFailureToMessage(failure))),
      (payments) => emit(PaymentsLoaded(payments)),
    );
  }

  Future<void> _onLoadPaymentsByTenantId(
    LoadPaymentsByTenantId event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await getPaymentsByTenantIdUseCase(event.tenantId);
    result.fold(
      (failure) => emit(PaymentError(_mapFailureToMessage(failure))),
      (payments) => emit(PaymentsLoaded(payments)),
    );
  }

  Future<void> _onLoadPaymentsByScheduledPaymentId(
    LoadPaymentsByScheduledPaymentId event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await getPaymentsByScheduledPaymentIdUseCase(
      event.scheduledPaymentId,
    );
    result.fold(
      (failure) => emit(PaymentError(_mapFailureToMessage(failure))),
      (payments) => emit(PaymentsLoaded(payments)),
    );
  }

  Future<void> _onLoadPaymentDetailsById(
    LoadPaymentDetailsById event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await getPaymentByIdUseCase(event.paymentId);
    result.fold(
      (failure) => emit(PaymentError(_mapFailureToMessage(failure))),
      (payment) => emit(PaymentLoaded(payment)),
    );
  }

  Future<void> _onDeleteRecordedPayment(
    DeleteRecordedPayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await deletePaymentUseCase(event.paymentId);
    result.fold(
      (failure) => emit(PaymentError(_mapFailureToMessage(failure))),
      (_) => emit(PaymentDeletedSuccess()),
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
