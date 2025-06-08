import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/lease_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/lease_repository.dart';
import 'package:logger/logger.dart';

class UpdateLeaseUseCase {
  final LeaseRepository leaseRepository;
  final Logger _logger = Logger();

  UpdateLeaseUseCase(this.leaseRepository);

  Future<Either<Failure, Unit>> call(LeaseEntity lease) async {
    if (lease.leaseId == null) {
      _logger.w('Lease ID cannot be null for update.');
      return Left(ValidationFailure('Lease ID cannot be null for update.'));
    }
    if (lease.startDate.isAfter(lease.endDate)) {
      _logger.w('Lease start date cannot be after end date for update.');
      return Left(
        ValidationFailure('Lease start date cannot be after end date.'),
      );
    }
    if (lease.rentAmount <= 0) {
      _logger.w('Lease rent amount must be positive for update.');
      return Left(ValidationFailure('Lease rent amount must be positive.'));
    }
    // TODO: Consider implications of updating a lease on existing ScheduledPayments
    // This might involve deleting/recreating or updating scheduled payments.
    return await leaseRepository.updateLease(lease);
  }
}
