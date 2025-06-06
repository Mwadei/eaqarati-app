import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/units_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/units_repository.dart';

class UpdateUnitUseCase {
  final UnitsRepository unitsRepository;

  UpdateUnitUseCase({required this.unitsRepository});

  Future<Either<Failure, Unit>> call(UnitsEntity units) async {
    return await unitsRepository.updateUnit(units);
  }
}
