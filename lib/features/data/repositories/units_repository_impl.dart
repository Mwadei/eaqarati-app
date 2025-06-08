import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/data/models/units_model.dart';
import 'package:eaqarati_app/features/data/sources/local/unit_local_data_source.dart';
import 'package:eaqarati_app/features/domain/entities/units_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/units_repository.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class UnitsRepositoryImpl implements UnitsRepository {
  final UnitLocalDataSource unitLocalDataSource;

  UnitsRepositoryImpl({required this.unitLocalDataSource});

  @override
  Future<Either<Failure, int>> addUnit(UnitsEntity unit) async {
    try {
      final unitModels = UnitsModel(
        unitId: unit.unitId,
        propertyId: unit.propertyId,
        description: unit.description,
        status: unit.status,
        defaultRentAmount: unit.defaultRentAmount,
        unitNumber: unit.unitNumber,
        createdAt: unit.createdAt,
      );

      if (unitModels.unitId == null) {
        return Right(await unitLocalDataSource.addUnit(unitModels));
      } else {
        return Left(
          DatabaseFailure(
            'Unit ID must be null to add new Unit to Property via UnitsRepositoryImpl',
          ),
        );
      }
    } on DatabaseException catch (e) {
      Logger().e('Failed to add unit: ${e.toString()} via UnitsRepositoryImpl');
      return Future.value(
        Left(
          DatabaseFailure(
            'Failed to add unit: ${e.toString()} via UnitsRepositoryImpl',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUnit(int unitId) async {
    try {
      final count = await unitLocalDataSource.deleteUnit(unitId);
      if (count > 0) {
        return Right(unit);
      } else {
        return Left(
          NotFoundFailure(
            'Unit with ID $unitId not found for deletion via UnitsRepositoryImpl',
          ),
        );
      }
    } on DatabaseException catch (e) {
      Logger().e(
        'Failed to delete unit: ${e.toString()} via UnitsRepositoryImpl',
      );
      return Future.value(
        Left(
          DatabaseFailure(
            'Failed to delete unit: ${e.toString()} via UnitsRepositoryImpl',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<UnitsEntity>>> getAllUnits() async {
    try {
      final units = await unitLocalDataSource.getAllUnits();
      if (units.isNotEmpty) {
        return Right(units.map((data) => data as UnitsEntity).toList());
      } else {
        return Left(
          NotFoundFailure('Failed to get all units via UnitsRepositoryImpl'),
        );
      }
    } on DatabaseException catch (e) {
      Logger().e(
        'Failed to get all units: ${e.toString()} via UnitsRepositoryImpl',
      );
      return Future.value(
        Left(
          DatabaseFailure(
            'Failed to get all units: ${e.toString()} via UnitsRepositoryImpl',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UnitsEntity>> getUnitById(int unitId) async {
    try {
      final units = await unitLocalDataSource.getUnitById(unitId);
      return Right(units as UnitsEntity);
    } on DatabaseException catch (e) {
      Logger().e(
        'Failed to get unit by ID: ${e.toString()} via UnitsRepositoryImpl',
      );
      return Future.value(
        Left(
          DatabaseFailure(
            'Failed to get unit by ID: ${e.toString()} via UnitsRepositoryImpl',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<UnitsEntity>>> getUnitsByPropertyId(
    int propertyId,
  ) async {
    try {
      final units = await unitLocalDataSource.getUnitsByPropertyId(propertyId);
      if (units.isNotEmpty) {
        return Right(units.map((data) => data as UnitsEntity).toList());
      } else {
        return Left(
          NotFoundFailure(
            'There is no Units with Property $propertyId via UnitsRepositoryImpl',
          ),
        );
      }
    } on DatabaseException catch (e) {
      Logger().f(
        'There is no Units with Property: ${e.toString()} via UnitsRepositoryImpl',
      );
      return Future.value(
        Left(
          DatabaseFailure(
            'There is no Units with Property: ${e.toString()} via UnitsRepositoryImpl',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUnit(UnitsEntity units) async {
    try {
      final unitModel = UnitsModel(
        unitId: units.unitId,
        propertyId: units.propertyId,
        description: units.description,
        status: units.status,
        defaultRentAmount: units.defaultRentAmount,
        unitNumber: units.unitNumber,
        createdAt: units.createdAt,
      );

      await unitLocalDataSource.updateUnit(unitModel);
      return Right(unit);
    } on DatabaseException catch (e) {
      Logger().f(
        'Failed to update Unit: ${e.toString()} via UnitsRepositoryImpl',
      );
      return Future.value(
        Left(
          DatabaseFailure(
            'Failed to update Unit: ${e.toString()} via UnitsRepositoryImpl',
          ),
        ),
      );
    }
  }
}
