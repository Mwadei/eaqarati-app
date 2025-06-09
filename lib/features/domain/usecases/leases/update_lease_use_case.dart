import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/lease_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/lease_repository.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class UpdateLeaseUseCase {
  final LeaseRepository leaseRepository;
  final Logger _logger = Logger();

  UpdateLeaseUseCase(this.leaseRepository);

  Future<Either<Failure, Unit>> call(
    LeaseEntity lease, {
    Transaction? transaction,
  }) async {
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
    return await leaseRepository.updateLease(lease, transaction: transaction);
  }
}
