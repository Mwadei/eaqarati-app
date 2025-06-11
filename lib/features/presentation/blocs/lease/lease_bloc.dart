import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/lease_entity.dart';
import 'package:eaqarati_app/features/domain/usecases/leases/delete_lease_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/leases/get_active_leases_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/leases/get_all_leases_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/leases/get_lease_by_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/leases/get_leases_by_tenant_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/leases/get_leases_by_unit_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/orchestration/create_lease_with_schedule_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/orchestration/update_lease_with_schedule_use_case.dart';
import 'package:equatable/equatable.dart';

part 'lease_event.dart';
part 'lease_state.dart';

class LeaseBloc extends Bloc<LeaseEvent, LeaseState> {
  final GetActiveLeasesUseCase getActiveLeasesUseCase;
  final GetAllLeasesUseCase getAllLeasesUseCase;
  final GetLeaseByIdUseCase getLeaseByIdUseCase;
  final GetLeasesByTenantIdUseCase getLeasesByTenantIdUseCase;
  final GetLeasesByUnitIdUseCase getLeasesByUnitIdUseCase;
  final CreateLeaseWithScheduleUseCase createLeaseWithScheduleUseCase;
  final UpdateLeaseWithScheduleUseCase updateLeaseWithScheduleUseCase;
  final DeleteLeaseUseCase deleteLeaseUseCase;

  LeaseBloc({
    required this.getActiveLeasesUseCase,
    required this.getAllLeasesUseCase,
    required this.getLeaseByIdUseCase,
    required this.getLeasesByTenantIdUseCase,
    required this.getLeasesByUnitIdUseCase,
    required this.deleteLeaseUseCase,
    required this.createLeaseWithScheduleUseCase,
    required this.updateLeaseWithScheduleUseCase,
  }) : super(LeaseInitial()) {
    on<LoadAllLeases>(_onLoadAllLeases);
    on<LoadLeasesByUnitId>(_onLoadLeasesByUnitId);
    on<LoadLeasesByTenantId>(_onLoadLeasesByTenantId);
    on<LoadActiveLeases>(_onLoadActiveLeases);
    on<LoadLeaseById>(_onLoadLeaseById);
    on<CreateNewLease>(_onCreateNewLease);
    on<UpdateExistingLeaseDetails>(_onUpdateExistingLease);
    on<DeleteExistingLease>(_onDeleteExistingLease);
  }

  Future<void> _onLoadAllLeases(
    LoadAllLeases event,
    Emitter<LeaseState> emit,
  ) async {
    emit(LeaseLoading());
    final failureOrLeases = await getAllLeasesUseCase();
    failureOrLeases.fold(
      (failure) => emit(LeaseError(_mapFailureToMessage(failure))),
      (leases) => emit(LeasesLoaded(leases)),
    );
  }

  Future<void> _onLoadLeasesByUnitId(
    LoadLeasesByUnitId event,
    Emitter<LeaseState> emit,
  ) async {
    emit(LeaseLoading());
    final failureOrLeases = await getLeasesByUnitIdUseCase(event.unitId);
    failureOrLeases.fold(
      (failure) => emit(LeaseError(_mapFailureToMessage(failure))),
      (leases) => emit(LeasesLoaded(leases)),
    );
  }

  Future<void> _onLoadLeasesByTenantId(
    LoadLeasesByTenantId event,
    Emitter<LeaseState> emit,
  ) async {
    emit(LeaseLoading());
    final failureOrLeases = await getLeasesByTenantIdUseCase(event.tenantId);
    failureOrLeases.fold(
      (failure) => emit(LeaseError(_mapFailureToMessage(failure))),
      (leases) => emit(LeasesLoaded(leases)),
    );
  }

  Future<void> _onLoadActiveLeases(
    LoadActiveLeases event,
    Emitter<LeaseState> emit,
  ) async {
    emit(LeaseLoading());
    final failureOrLeases = await getActiveLeasesUseCase();
    failureOrLeases.fold(
      (failure) => emit(LeaseError(_mapFailureToMessage(failure))),
      (leases) => emit(LeasesLoaded(leases)),
    );
  }

  Future<void> _onLoadLeaseById(
    LoadLeaseById event,
    Emitter<LeaseState> emit,
  ) async {
    emit(LeaseLoading());
    final failureOrLease = await getLeaseByIdUseCase(event.leaseId);
    failureOrLease.fold(
      (failure) => emit(LeaseError(_mapFailureToMessage(failure))),
      (lease) => emit(LeaseLoaded(lease)),
    );
  }

  Future<void> _onCreateNewLease(
    CreateNewLease event,
    Emitter<LeaseState> emit,
  ) async {
    emit(LeaseLoading());
    final failureOrLease = await createLeaseWithScheduleUseCase(event.lease);
    failureOrLease.fold(
      (failure) => emit(LeaseError(_mapFailureToMessage(failure))),
      (leaseId) => emit(LeaseCreatedSuccess(leaseId)),
    );
  }

  Future<void> _onUpdateExistingLease(
    UpdateExistingLeaseDetails event,
    Emitter<LeaseState> emit,
  ) async {
    emit(LeaseLoading());
    final failureOrLease = await updateLeaseWithScheduleUseCase(event.lease);
    failureOrLease.fold(
      (failure) => emit(LeaseError(_mapFailureToMessage(failure))),
      (_) => emit(LeaseUpdateSuccess()),
    );
  }

  Future<void> _onDeleteExistingLease(
    DeleteExistingLease event,
    Emitter<LeaseState> emit,
  ) async {
    emit(LeaseLoading());
    final failureOrLease = await deleteLeaseUseCase(event.leaseId);
    failureOrLease.fold(
      (failure) => emit(LeaseError(_mapFailureToMessage(failure))),
      (_) => emit(LeaseDeleteSuccess()),
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
