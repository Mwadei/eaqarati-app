part of 'property_bloc.dart';

sealed class PropertyEvent extends Equatable {
  const PropertyEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllProperties extends PropertyEvent {}

class LoadPropertyById extends PropertyEvent {
  final int propertyId;

  const LoadPropertyById(this.propertyId);

  @override
  List<Object?> get props => [propertyId];
}

class AddNewProperty extends PropertyEvent {
  final PropertyEntity property;

  const AddNewProperty(this.property);

  @override
  List<Object?> get props => [property];
}

class UpdateExistingProperty extends PropertyEvent {
  final PropertyEntity property;

  const UpdateExistingProperty(this.property);

  @override
  List<Object?> get props => [property];
}

class DeleteExistingProperty extends PropertyEvent {
  final int propertyId;

  const DeleteExistingProperty(this.propertyId);

  @override
  List<Object?> get props => [propertyId];
}
