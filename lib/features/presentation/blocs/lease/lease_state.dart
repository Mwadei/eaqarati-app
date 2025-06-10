part of 'lease_bloc.dart';

sealed class LeaseState extends Equatable {
  const LeaseState();
  
  @override
  List<Object> get props => [];
}

final class LeaseInitial extends LeaseState {}
