import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/repositories/lease_repository.dart';

class DeleteLeaseUseCase {
  final LeaseRepository leaseRepository;
  DeleteLeaseUseCase(this.leaseRepository);
  Future<Either<Failure, Unit>> call(int leaseId) async {
    return await leaseRepository.deleteLease(leaseId);
  }
}
