import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/units_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/units_repository.dart';
import 'package:logger/logger.dart';

class AddUnitUseCase {
  final UnitsRepository unitsRepository;

  AddUnitUseCase({required this.unitsRepository});

  Future<Either<Failure, int>> call(UnitsEntity unit) async {
    if (unit.unitNumber.isEmpty) {
      Logger().e('unit number cannot be empty via AddUnitUseCase.');
      return Left(
        ValidationFailure('unit number cannot be empty via AddUnitUseCase.'),
      );
    }
    return await unitsRepository.addUnit(unit);
  }
}
