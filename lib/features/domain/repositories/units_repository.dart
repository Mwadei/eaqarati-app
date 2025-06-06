import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/units_entity.dart';

abstract class UnitsRepository {
  Future<Either<Failure, UnitsEntity>> getUnitById(int unitId);
  Future<Either<Failure, List<UnitsEntity>>> getAllUnits();
  Future<Either<Failure, List<UnitsEntity>>> getUnitsByPropertyId(
    int propertyId,
  );
  Future<Either<Failure, int>> addUnit(UnitsEntity unit);
  Future<Either<Failure, Unit>> updateUnit(UnitsEntity units);
  Future<Either<Failure, Unit>> deleteUnit(int unitId);
}
