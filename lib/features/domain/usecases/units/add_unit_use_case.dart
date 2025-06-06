import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/units_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/units_repository.dart';

class AddUnitUseCase {
  final UnitsRepository unitsRepository;

  AddUnitUseCase({required this.unitsRepository});

  Future<Either<Failure, int>> call(UnitsEntity unit) async {
    return await unitsRepository.addUnit(unit);
  }
}
