part of 'units_bloc.dart';

sealed class UnitsEvent extends Equatable {
  const UnitsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllUnits extends UnitsEvent {}

class LoadUnitsByPropertyId extends UnitsEvent {
  final int propertyId;

  const LoadUnitsByPropertyId(this.propertyId);

  @override
  List<Object?> get props => [propertyId];
}

class LoadUnitById extends UnitsEvent {
  final int unitId;

  const LoadUnitById(this.unitId);

  @override
  List<Object?> get props => [unitId];
}

class AddNewUnit extends UnitsEvent {
  final UnitsEntity unit;

  const AddNewUnit(this.unit);

  @override
  List<Object?> get props => [unit];
}

class UpdateExistingUnit extends UnitsEvent {
  final UnitsEntity unit;
  const UpdateExistingUnit(this.unit);

  @override
  List<Object?> get props => [unit];
}

class DeleteExistingUnit extends UnitsEvent {
  final int unitId;
  const DeleteExistingUnit(this.unitId);

  @override
  List<Object?> get props => [unitId];
}
