import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/repositories/lease_repository.dart';

class DeleteLeaseUseCase {
  final LeaseRepository leaseRepository;
  DeleteLeaseUseCase(this.leaseRepository);
  Future<Either<Failure, Unit>> call(int leaseId) async {
    // TODO: Consider implications: what happens to related ScheduledPayments and Payments?
    // The DB schema has ON DELETE CASCADE for ScheduledPayments if lease is deleted.
    // Payments are also linked to ScheduledPayments or Leases.
    return await leaseRepository.deleteLease(leaseId);
  }
}
