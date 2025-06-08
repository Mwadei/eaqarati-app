import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/lease_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/lease_repository.dart';

class GetActiveLeasesUseCase {
  final LeaseRepository leaseRepository;
  GetActiveLeasesUseCase(this.leaseRepository);
  Future<Either<Failure, List<LeaseEntity>>> call() async {
    return await leaseRepository.getActiveLeases();
  }
}
