import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/units_entity.dart';
import 'package:eaqarati_app/features/domain/usecases/units/add_unit_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/units/delete_unit_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/units/get_all_units_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/units/get_unit_by_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/units/get_units_by_property_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/units/update_unit_use_case.dart';
import 'package:equatable/equatable.dart';

part 'units_event.dart';
part 'units_state.dart';

class UnitsBloc extends Bloc<UnitsEvent, UnitsState> {
  final AddUnitUseCase addUnitUseCase;
  final GetAllUnitsUseCase getAllUnitsUseCase;
  final GetUnitsByPropertyIdUseCase getUnitsByPropertyIdUseCase;
  final GetUnitByIdUseCase getUnitByIdUseCase;
  final UpdateUnitUseCase updateUnitUseCase;
  final DeleteUnitUseCase deleteUnitUseCase;

  UnitsBloc({
    required this.addUnitUseCase,
    required this.getAllUnitsUseCase,
    required this.getUnitsByPropertyIdUseCase,
    required this.getUnitByIdUseCase,
    required this.updateUnitUseCase,
    required this.deleteUnitUseCase,
  }) : super(UnitsInitial()) {
    on<LoadAllUnits>(_onLoadAllUnits);
    on<LoadUnitsByPropertyId>(_onLoadUnitsByPropertyId);
    on<LoadUnitById>(_onLoadUnitById);
    on<AddNewUnit>(_onAddNewUnit);
    on<UpdateExistingUnit>(_onUpdateExistingUnit);
    on<DeleteExistingUnit>(_onDeleteExistingUnit);
  }

  Future<void> _onLoadAllUnits(
    LoadAllUnits event,
    Emitter<UnitsState> emit,
  ) async {
    emit(UnitsLoading());
    final failureOrUnits = await getAllUnitsUseCase();
    failureOrUnits.fold(
      (failure) => emit(UnitError(_mapFailureToMessage(failure))),
      (units) => emit(UnitsLoaded(units)),
    );
  }

  Future<void> _onLoadUnitsByPropertyId(
    LoadUnitsByPropertyId event,
    Emitter<UnitsState> emit,
  ) async {
    emit(UnitsLoading());
    final failureOrUnits = await getUnitsByPropertyIdUseCase(event.propertyId);
    failureOrUnits.fold(
      (failure) => emit(UnitError(_mapFailureToMessage(failure))),
      (units) => emit(UnitsLoaded(units)),
    );
  }

  Future<void> _onLoadUnitById(
    LoadUnitById event,
    Emitter<UnitsState> emit,
  ) async {
    emit(UnitsLoading());
    final failureOrUnit = await getUnitByIdUseCase(event.unitId);
    failureOrUnit.fold(
      (failure) => emit(UnitError(_mapFailureToMessage(failure))),
      (unit) => emit(UnitLoaded(unit)),
    );
  }

  Future<void> _onAddNewUnit(AddNewUnit event, Emitter<UnitsState> emit) async {
    emit(UnitsLoading());
    final failureOrUnitId = await addUnitUseCase(event.unit);
    failureOrUnitId.fold(
      (failure) => emit(UnitError(_mapFailureToMessage(failure))),
      (unitId) => emit(UnitAddedSuccess(unitId)),
    );
  }

  Future<void> _onUpdateExistingUnit(
    UpdateExistingUnit event,
    Emitter<UnitsState> emit,
  ) async {
    emit(UnitsLoading());
    final failureOrSuccess = await updateUnitUseCase(event.unit);
    failureOrSuccess.fold(
      (failure) => emit(UnitError(_mapFailureToMessage(failure))),
      (_) => emit(UnitUpdateSuccess()),
    );
  }

  Future<void> _onDeleteExistingUnit(
    DeleteExistingUnit event,
    Emitter<UnitsState> emit,
  ) async {
    emit(UnitsLoading());
    final failureOrSuccess = await deleteUnitUseCase(event.unitId);
    failureOrSuccess.fold(
      (failure) => emit(UnitError(_mapFailureToMessage(failure))),
      (_) => emit(UnitDeleteSuccess()),
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
