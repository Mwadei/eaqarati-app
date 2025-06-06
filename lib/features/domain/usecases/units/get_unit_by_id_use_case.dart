import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/units_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/units_repository.dart';

class GetUnitByIdUseCase {
  final UnitsRepository unitsRepository;

  GetUnitByIdUseCase({required this.unitsRepository});

  Future<Either<Failure, UnitsEntity>> call(int unitId) async {
    return await unitsRepository.getUnitById(unitId);
  }
}
