part of 'tenant_bloc.dart';

sealed class TenantState extends Equatable {
  const TenantState();

  @override
  List<Object?> get props => [];
}

final class TenantInitial extends TenantState {}

class TenantLoading extends TenantState {}

class TenantsLoaded extends TenantState {
  final List<TenantEntity> tenants;
  const TenantsLoaded(this.tenants);

  @override
  List<Object?> get props => [tenants];
}

class TenantLoaded extends TenantState {
  final TenantEntity tenant;
  const TenantLoaded(this.tenant);

  @override
  List<Object?> get props => [tenant];
}

class TenantAddedSuccess extends TenantState {
  final int tenantId;
  const TenantAddedSuccess(this.tenantId);

  @override
  List<Object?> get props => [tenantId];
}

class TenantUpdateSuccess extends TenantState {}

class TenantDeleteSuccess extends TenantState {}

class TenantError extends TenantState {
  final String message;
  const TenantError(this.message);

  @override
  List<Object?> get props => [message];
}
