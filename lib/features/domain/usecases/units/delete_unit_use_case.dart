import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/repositories/units_repository.dart';

class DeleteUnitUseCase {
  final UnitsRepository unitsRepository;

  DeleteUnitUseCase({required this.unitsRepository});

  Future<Either<Failure, Unit>> call(int unitId) async {
    return await unitsRepository.deleteUnit(unitId);
  }
}
