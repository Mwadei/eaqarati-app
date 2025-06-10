part of 'tenant_bloc.dart';

sealed class TenantState extends Equatable {
  const TenantState();
  
  @override
  List<Object> get props => [];
}

final class TenantInitial extends TenantState {}
