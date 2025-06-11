part of 'lease_bloc.dart';

sealed class LeaseEvent extends Equatable {
  const LeaseEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllLeases extends LeaseEvent {}

class LoadActiveLeases extends LeaseEvent {}

class LoadLeaseById extends LeaseEvent {
  final int leaseId;

  const LoadLeaseById(this.leaseId);

  @override
  List<Object?> get props => [leaseId];
}

class LoadLeasesByTenantId extends LeaseEvent {
  final int tenantId;

  const LoadLeasesByTenantId(this.tenantId);

  @override
  List<Object?> get props => [tenantId];
}

class LoadLeasesByUnitId extends LeaseEvent {
  final int unitId;

  const LoadLeasesByUnitId(this.unitId);

  @override
  List<Object?> get props => [unitId];
}

class CreateNewLease extends LeaseEvent {
  final LeaseEntity lease;
  const CreateNewLease(this.lease);
  @override
  List<Object?> get props => [lease];
}

class UpdateExistingLeaseDetails extends LeaseEvent {
  final LeaseEntity lease;
  const UpdateExistingLeaseDetails(this.lease);
  @override
  List<Object?> get props => [lease];
}

class DeleteExistingLease extends LeaseEvent {
  final int leaseId;
  const DeleteExistingLease(this.leaseId);
  @override
  List<Object?> get props => [leaseId];
}
