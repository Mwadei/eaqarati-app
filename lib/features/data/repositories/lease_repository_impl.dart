import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/data/models/lease_model.dart';
import 'package:eaqarati_app/features/data/sources/local/lease_local_data_source.dart';
import 'package:eaqarati_app/features/domain/entities/lease_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/lease_repository.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class LeaseRepositoryImpl implements LeaseRepository {
  final LeaseLocalDataSource localDataSource;
  final Logger _logger = Logger();

  LeaseRepositoryImpl({required this.localDataSource});

  LeaseModel _toModel(LeaseEntity entity) {
    return LeaseModel(
      leaseId: entity.leaseId,
      unitId: entity.unitId,
      tenantId: entity.tenantId,
      startDate: entity.startDate,
      endDate: entity.endDate,
      rentAmount: entity.rentAmount,
      paymentFrequencyType: entity.paymentFrequencyType,
      paymentFrequencyValue: entity.paymentFrequencyValue,
      depositAmount: entity.depositAmount,
      notes: entity.notes,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
    );
  }

  @override
  Future<Either<Failure, int>> addLease(LeaseEntity lease) async {
    try {
      final leaseModel = _toModel(lease);
      if (leaseModel.leaseId != null) {
        _logger.w('Lease ID must be null to add a new lease.');
        return Left(
          DatabaseFailure('Lease ID must be null to add a new lease.'),
        );
      }
      final id = await localDataSource.addLease(leaseModel);
      return Right(id);
    } on DatabaseException catch (e) {
      _logger.e('DBException adding lease: ${e.toString()}');
      return Left(DatabaseFailure('Failed to add lease: $e'));
    } catch (e) {
      _logger.e('Unexpected error adding lease: ${e.toString()}');
      return Left(
        ServerFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteLease(int leaseId) async {
    try {
      final count = await localDataSource.deleteLease(leaseId);
      if (count > 0) {
        return Right(unit);
      } else {
        _logger.w('Lease with ID $leaseId not found for deletion.');
        return Left(NotFoundFailure('Lease with ID $leaseId not found.'));
      }
    } on DatabaseException catch (e) {
      _logger.e('DBException deleting lease: ${e.toString()}');
      return Left(DatabaseFailure('Failed to delete lease: $e'));
    } catch (e) {
      _logger.e('Unexpected error deleting lease: ${e.toString()}');
      return Left(
        ServerFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<LeaseEntity>>> getAllLeases() async {
    try {
      final leaseModels = await localDataSource.getAllLeases();
      return Right(leaseModels.map((model) => model as LeaseEntity).toList());
    } on DatabaseException catch (e) {
      _logger.e('DBException getting all leases: ${e.toString()}');
      return Left(DatabaseFailure('Failed to get all leases: $e'));
    } catch (e) {
      _logger.e('Unexpected error getting all leases: ${e.toString()}');
      return Left(
        ServerFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, LeaseEntity>> getLeaseById(int leaseId) async {
    try {
      final leaseModel = await localDataSource.getLeaseById(leaseId);
      if (leaseModel != null) {
        return Right(leaseModel as LeaseEntity);
      } else {
        _logger.w('Lease with ID $leaseId not found.');
        return Left(NotFoundFailure('Lease with ID $leaseId not found.'));
      }
    } on DatabaseException catch (e) {
      _logger.e('DBException getting lease by ID $leaseId: ${e.toString()}');
      return Left(DatabaseFailure('Failed to get lease: $e'));
    } catch (e) {
      _logger.e(
        'Unexpected error getting lease by ID $leaseId: ${e.toString()}',
      );
      return Left(
        ServerFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateLease(LeaseEntity lease) async {
    try {
      if (lease.leaseId == null) {
        _logger.w('Lease ID cannot be null for an update operation.');
        return Left(DatabaseFailure('Lease ID cannot be null for an update.'));
      }
      final leaseModel = _toModel(lease);
      final count = await localDataSource.updateLease(leaseModel);
      if (count > 0) {
        return Right(unit);
      } else {
        _logger.w(
          'Lease with ID ${lease.leaseId} not found for update or no data changed.',
        );
        return Left(
          NotFoundFailure(
            'Lease with ID ${lease.leaseId} not found for update or no data changed.',
          ),
        );
      }
    } on DatabaseException catch (e) {
      _logger.e('DBException updating lease: ${e.toString()}');
      return Left(DatabaseFailure('Failed to update lease: $e'));
    } catch (e) {
      _logger.e('Unexpected error updating lease: ${e.toString()}');
      return Left(
        ServerFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<LeaseEntity>>> getLeasesByUnitId(
    int unitId,
  ) async {
    try {
      final leaseModels = await localDataSource.getLeasesByUnitId(unitId);
      return Right(leaseModels.map((model) => model as LeaseEntity).toList());
    } on DatabaseException catch (e) {
      _logger.e('DBException getting leases for unit $unitId: ${e.toString()}');
      return Left(DatabaseFailure('Failed to get leases for unit: $e'));
    } catch (e) {
      _logger.e(
        'Unexpected error getting leases for unit $unitId: ${e.toString()}',
      );
      return Left(
        ServerFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<LeaseEntity>>> getLeasesByTenantId(
    int tenantId,
  ) async {
    try {
      final leaseModels = await localDataSource.getLeasesByTenantId(tenantId);
      return Right(leaseModels.map((model) => model as LeaseEntity).toList());
    } on DatabaseException catch (e) {
      _logger.e(
        'DBException getting leases for tenant $tenantId: ${e.toString()}',
      );
      return Left(DatabaseFailure('Failed to get leases for tenant: $e'));
    } catch (e) {
      _logger.e(
        'Unexpected error getting leases for tenant $tenantId: ${e.toString()}',
      );
      return Left(
        ServerFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<LeaseEntity>>> getActiveLeases() async {
    try {
      final leaseModels = await localDataSource.getActiveLeases();
      return Right(leaseModels.map((model) => model as LeaseEntity).toList());
    } on DatabaseException catch (e) {
      _logger.e('DBException getting active leases: ${e.toString()}');
      return Left(DatabaseFailure('Failed to get active leases: $e'));
    } catch (e) {
      _logger.e('Unexpected error getting active leases: ${e.toString()}');
      return Left(
        ServerFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }
}
