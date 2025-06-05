import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/Property_entity.dart';

abstract class PropertyRepository {
  Future<Either<Failure, PropertyEntity>> getPropertyById(int propertyId);
  Future<Either<Failure, List<PropertyEntity>>> getAllProperties();
  Future<Either<Failure, int>> addProperty(PropertyEntity property);
  Future<Either<Failure, Unit>> updateProperty(PropertyEntity property);
  Future<Either<Failure, Unit>> deleteProperty(int propertyId);
}
