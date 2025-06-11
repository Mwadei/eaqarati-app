part of 'tenant_bloc.dart';

sealed class TenantEvent extends Equatable {
  const TenantEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllTenants extends TenantEvent {}

class LoadTenantById extends TenantEvent {
  final int tenantId;
  const LoadTenantById(this.tenantId);

  @override
  List<Object?> get props => [tenantId];
}

class AddNewTenant extends TenantEvent {
  final TenantEntity tenant;
  const AddNewTenant(this.tenant);

  @override
  List<Object?> get props => [tenant];
}

class UpdateExistingTenant extends TenantEvent {
  final TenantEntity tenant;
  const UpdateExistingTenant(this.tenant);

  @override
  List<Object?> get props => [tenant];
}

class DeleteExistingTenant extends TenantEvent {
  final int tenantId;
  const DeleteExistingTenant(this.tenantId);

  @override
  List<Object?> get props => [tenantId];
}
