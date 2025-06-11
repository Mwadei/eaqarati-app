part of 'lease_bloc.dart';

sealed class LeaseState extends Equatable {
  const LeaseState();

  @override
  List<Object?> get props => [];
}

class LeaseInitial extends LeaseState {}

class LeaseLoading extends LeaseState {}

class LeasesLoaded extends LeaseState {
  final List<LeaseEntity> leases;

  const LeasesLoaded(this.leases);

  @override
  List<Object?> get props => [leases];
}

class LeaseLoaded extends LeaseState {
  final LeaseEntity lease;

  const LeaseLoaded(this.lease);

  @override
  List<Object?> get props => [lease];
}

class LeaseCreatedSuccess extends LeaseState {
  final int leaseId;

  const LeaseCreatedSuccess(this.leaseId);

  @override
  List<Object?> get props => [leaseId];
}

class LeaseUpdateSuccess extends LeaseState {}

class LeaseDeleteSuccess extends LeaseState {}

class LeaseError extends LeaseState {
  final String message;

  const LeaseError(this.message);

  @override
  List<Object?> get props => [message];
}
