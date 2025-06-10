part of 'units_bloc.dart';

sealed class UnitsState extends Equatable {
  const UnitsState();

  @override
  List<Object?> get props => [];
}

final class UnitsInitial extends UnitsState {}

class UnitsLoading extends UnitsState {}

class UnitsLoaded extends UnitsState {
  final List<UnitsEntity> units;

  const UnitsLoaded(this.units);
  @override
  List<Object?> get props => [units];
}

class UnitLoaded extends UnitsState {
  final UnitsEntity unit;
  const UnitLoaded(this.unit);

  @override
  List<Object?> get props => [unit];
}

class UnitAddedSuccess extends UnitsState {
  final int unitId;
  const UnitAddedSuccess(this.unitId);

  @override
  List<Object?> get props => [unitId];
}

class UnitUpdateSuccess extends UnitsState {}

class UnitDeleteSuccess extends UnitsState {}

class UnitError extends UnitsState {
  final String message;
  const UnitError(this.message);

  @override
  List<Object?> get props => [message];
}
