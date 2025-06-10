part of 'units_bloc.dart';

sealed class UnitsState extends Equatable {
  const UnitsState();
  
  @override
  List<Object> get props => [];
}

final class UnitsInitial extends UnitsState {}
