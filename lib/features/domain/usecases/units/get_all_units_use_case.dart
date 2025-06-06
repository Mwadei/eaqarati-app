import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/units_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/units_repository.dart';

class GetAllUnitsUseCase {
  final UnitsRepository unitsRepository;

  GetAllUnitsUseCase({required this.unitsRepository});

  Future<Either<Failure, List<UnitsEntity>>> call() async {
    return await unitsRepository.getAllUnits();
  }
}
