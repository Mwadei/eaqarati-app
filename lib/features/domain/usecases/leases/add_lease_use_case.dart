import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/lease_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/lease_repository.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class AddLeaseUseCase {
  final LeaseRepository leaseRepository;
  final Logger _logger = Logger();

  AddLeaseUseCase(this.leaseRepository);

  Future<Either<Failure, int>> call(
    LeaseEntity lease, {
    Transaction? transaction,
  }) async {
    if (lease.startDate.isAfter(lease.endDate)) {
      _logger.w('Lease start date cannot be after end date.');
      return Left(
        ValidationFailure('Lease start date cannot be after end date.'),
      );
    }
    if (lease.rentAmount <= 0) {
      _logger.w('Lease rent amount must be positive.');
      return Left(ValidationFailure('Lease rent amount must be positive.'));
    }
    return await leaseRepository.addLease(lease, transaction: transaction);
  }
}
