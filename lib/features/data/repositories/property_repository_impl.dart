import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/data/models/property_model.dart';
import 'package:eaqarati_app/features/data/sources/local/property_local_data_source.dart';
import 'package:eaqarati_app/features/domain/entities/property_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/property_repository.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  final PropertyLocalDataSource localDataSource;
  PropertyRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, int>> addProperty(PropertyEntity property) async {
    try {
      final propertyModel = PropertyModel(
        propertyId: property.propertyId,
        name: property.name,
        address: property.address,
        type: property.type,
        notes: property.notes,
        createdAt: property.createdAt,
      );

      if (propertyModel.propertyId == null) {
        return Right(await localDataSource.addProperty(propertyModel));
      } else {
        return Left(
          DatabaseFailure(
            'property ID must be null to add new property via PropertyRepositoryImpl',
          ),
        );
      }
    } on DatabaseException catch (e) {
      Logger().e(
        'Failed to add property: ${e.toString()} via PropertyRepositoryImpl',
      );
      return Future.value(
        Left(
          DatabaseFailure(
            'Failed to add property: ${e.toString()} via PropertyRepositoryImpl',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProperty(int propertyId) async {
    try {
      final count = await localDataSource.deleteProperty(propertyId);
      if (count > 0) {
        return Right(unit);
      } else {
        return Left(
          NotFoundFailure(
            'Property with ID $propertyId not found for deletion via PropertyRepositoryImpl',
          ),
        );
      }
    } on DatabaseException catch (e) {
      Logger().e(
        'Failed to delete property: ${e.toString()} via PropertyRepositoryImpl',
      );
      return Future.value(
        Left(
          DatabaseFailure(
            'Failed to delete property: ${e.toString()} via PropertyRepositoryImpl',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<PropertyEntity>>> getAllProperties() async {
    try {
      final propertyModels = await localDataSource.getAllProperties();

      return Right(
        propertyModels.map((data) => data as PropertyEntity).toList(),
      );
    } on DatabaseException catch (e) {
      Logger().e(
        'Failed to get all properties: ${e.toString()} via PropertyRepositoryImpl',
      );
      return Future.value(
        Left(
          DatabaseFailure(
            'Failed to get all properties: ${e.toString()} via PropertyRepositoryImpl',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, PropertyEntity>> getPropertyById(
    int propertyId,
  ) async {
    try {
      final propertyModel = await localDataSource.getPropertyById(propertyId);

      return Right(propertyModel as PropertyEntity);
    } on DatabaseException catch (e) {
      Logger().e(
        'Failed to get property by ID: ${e.toString()} via PropertyRepositoryImpl',
      );
      return Future.value(
        Left(
          DatabaseFailure(
            'Failed to get property by ID: ${e.toString()} via PropertyRepositoryImpl',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProperty(PropertyEntity property) async {
    try {
      final propertyModel = PropertyModel(
        propertyId: property.propertyId,
        name: property.name,
        address: property.address,
        type: property.type,
        notes: property.notes,
        createdAt: property.createdAt,
      );

      await localDataSource.updateProperty(propertyModel);
      return Right(unit);
    } on DatabaseException catch (e) {
      Logger().e(
        'Failed to update property: ${e.toString()} via PropertyRepositoryImpl',
      );
      return Future.value(
        Left(
          DatabaseFailure(
            'Failed to update property: ${e.toString()} via PropertyRepositoryImpl',
          ),
        ),
      );
    }
  }
}
