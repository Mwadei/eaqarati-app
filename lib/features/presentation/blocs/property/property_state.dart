part of 'property_bloc.dart';

sealed class PropertyState extends Equatable {
  const PropertyState();

  @override
  List<Object?> get props => [];
}

final class PropertyInitial extends PropertyState {}

class PropertyLoading extends PropertyState {}

class PropertyLoaded extends PropertyState {
  final PropertyEntity property;

  const PropertyLoaded(this.property);

  @override
  List<Object?> get props => [property];
}

class PropertiesLoaded extends PropertyState {
  final List<PropertyEntity> properties;

  const PropertiesLoaded(this.properties);

  @override
  List<Object?> get props => [properties];
}

class PropertyAddedSuccess extends PropertyState {
  final int propertyId;

  const PropertyAddedSuccess(this.propertyId);

  @override
  List<Object?> get props => [propertyId];
}

class PropertyUpdateSuccess extends PropertyState {}

class PropertyDeleteSuccess extends PropertyState {}

class PropertyError extends PropertyState {
  final String message;

  const PropertyError(this.message);

  @override
  List<Object?> get props => [message];
}
