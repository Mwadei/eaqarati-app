import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/property_entity.dart';
import 'package:eaqarati_app/features/domain/usecases/property/add_property_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/property/delete_property_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/property/get_all_properties_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/property/get_property_by_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/property/update_property_use_case.dart';
import 'package:equatable/equatable.dart';

part 'property_event.dart';
part 'property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final AddPropertyUseCase addPropertyUseCase;
  final GetAllPropertiesUseCase getAllPropertiesUseCase;
  final GetPropertyByIdUseCase getPropertyByIdUseCase;
  final UpdatePropertyUseCase updatePropertyUseCase;
  final DeletePropertyUseCase deletePropertyUseCase;

  PropertyBloc({
    required this.addPropertyUseCase,
    required this.getAllPropertiesUseCase,
    required this.getPropertyByIdUseCase,
    required this.updatePropertyUseCase,
    required this.deletePropertyUseCase,
  }) : super(PropertyInitial()) {
    on<LoadAllProperties>(_onLoadAllProperties);
    on<LoadPropertyById>(_onLoadPropertyById);
    on<AddNewProperty>(_onAddNewProperty);
    on<UpdateExistingProperty>(_onUpdateExistingProperty);
    on<DeleteExistingProperty>(_onDeleteExistingProperty);
  }

  Future<void> _onLoadAllProperties(
    LoadAllProperties event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());

    final failureOrProperties = await getAllPropertiesUseCase();
    failureOrProperties.fold(
      (failure) => emit(PropertyError(_mapFailureToMessage(failure))),
      (properties) => emit(PropertiesLoaded(properties)),
    );
  }

  Future<void> _onLoadPropertyById(
    LoadPropertyById event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyInitial());
    final failureOrProperty = await getPropertyByIdUseCase(event.propertyId);
    failureOrProperty.fold(
      (failure) => emit(PropertyError(_mapFailureToMessage(failure))),
      (property) => emit(PropertyLoaded(property)),
    );
  }

  Future<void> _onAddNewProperty(
    AddNewProperty event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyInitial());
    final failureOrPropertyId = await addPropertyUseCase(event.property);
    failureOrPropertyId.fold(
      (failure) => emit(PropertyError(_mapFailureToMessage(failure))),
      (propertyId) => emit(PropertyAddedSuccess(propertyId)),
    );
  }

  Future<void> _onUpdateExistingProperty(
    UpdateExistingProperty event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyInitial());

    final failureOrUnit = await updatePropertyUseCase(event.property);
    failureOrUnit.fold(
      (failure) => emit(PropertyError(_mapFailureToMessage(failure))),
      (_) => emit(PropertyUpdateSuccess()),
    );
  }

  Future<void> _onDeleteExistingProperty(
    DeleteExistingProperty event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyInitial());

    final failureOrUnit = await deletePropertyUseCase(event.propertyId);
    failureOrUnit.fold(
      (failure) => emit(PropertyError(_mapFailureToMessage(failure))),
      (_) => emit(PropertyDeleteSuccess()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return 'Server Error: ${failure.message}';
      case DatabaseFailure _:
        return 'Database Error: ${failure.message}';
      case CacheFailure _:
        return 'Cache Error: ${failure.message}';
      case ValidationFailure _:
        return 'Validation Error: ${failure.message}';
      default:
        return 'Unexpected error: ${failure.message}';
    }
  }
}
