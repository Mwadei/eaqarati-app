import 'package:bloc/bloc.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/tenant_entity.dart';
import 'package:eaqarati_app/features/domain/usecases/tenants/add_tenant_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/tenants/delete_tenant_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/tenants/get_all_tenants_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/tenants/get_tenant_by_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/tenants/update_tenant_use_case.dart';
import 'package:equatable/equatable.dart';

part 'tenant_event.dart';
part 'tenant_state.dart';

class TenantBloc extends Bloc<TenantEvent, TenantState> {
  final AddTenantUseCase addTenantUseCase;
  final GetAllTenantsUseCase getAllTenantsUseCase;
  final GetTenantByIdUseCase getTenantByIdUseCase;
  final UpdateTenantUseCase updateTenantUseCase;
  final DeleteTenantUseCase deleteTenantUseCase;
  TenantBloc({
    required this.addTenantUseCase,
    required this.getAllTenantsUseCase,
    required this.getTenantByIdUseCase,
    required this.updateTenantUseCase,
    required this.deleteTenantUseCase,
  }) : super(TenantInitial()) {
    on<LoadAllTenants>(_onLoadAllTenants);
    on<LoadTenantById>(_onLoadTenantById);
    on<AddNewTenant>(_onAddNewTenant);
    on<UpdateExistingTenant>(_onUpdateExistingTenant);
    on<DeleteExistingTenant>(_onDeleteExistingTenant);
  }

  Future<void> _onLoadAllTenants(
    LoadAllTenants event,
    Emitter<TenantState> emit,
  ) async {
    emit(TenantLoading());
    final failureOrTenants = await getAllTenantsUseCase();
    failureOrTenants.fold(
      (failure) => emit(TenantError(_mapFailureToMessage(failure))),
      (tenants) => emit(TenantsLoaded(tenants)),
    );
  }

  Future<void> _onLoadTenantById(
    LoadTenantById event,
    Emitter<TenantState> emit,
  ) async {
    emit(TenantLoading());
    final failureOrTenant = await getTenantByIdUseCase(event.tenantId);
    failureOrTenant.fold(
      (failure) => emit(TenantError(_mapFailureToMessage(failure))),
      (tenant) => emit(TenantLoaded(tenant)),
    );
  }

  Future<void> _onAddNewTenant(
    AddNewTenant event,
    Emitter<TenantState> emit,
  ) async {
    emit(TenantLoading());
    final failureOrTenantId = await addTenantUseCase(event.tenant);
    failureOrTenantId.fold(
      (failure) => emit(TenantError(_mapFailureToMessage(failure))),
      (tenantId) => emit(TenantAddedSuccess(tenantId)),
    );
  }

  Future<void> _onUpdateExistingTenant(
    UpdateExistingTenant event,
    Emitter<TenantState> emit,
  ) async {
    emit(TenantLoading());
    final failureOrSuccess = await updateTenantUseCase(event.tenant);
    failureOrSuccess.fold(
      (failure) => emit(TenantError(_mapFailureToMessage(failure))),
      (_) => emit(TenantUpdateSuccess()),
    );
  }

  Future<void> _onDeleteExistingTenant(
    DeleteExistingTenant event,
    Emitter<TenantState> emit,
  ) async {
    emit(TenantLoading());
    final failureOrSuccess = await deleteTenantUseCase(event.tenantId);
    failureOrSuccess.fold(
      (failure) => emit(TenantError(_mapFailureToMessage(failure))),
      (_) => emit(TenantDeleteSuccess()),
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
