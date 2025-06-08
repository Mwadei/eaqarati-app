import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/lease_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/lease_repository.dart';

class GetLeaseByIdUseCase {
  final LeaseRepository leaseRepository;
  GetLeaseByIdUseCase(this.leaseRepository);
  Future<Either<Failure, LeaseEntity>> call(int leaseId) async {
    return await leaseRepository.getLeaseById(leaseId);
  }
}
