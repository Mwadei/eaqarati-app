import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/lease_entity.dart';

abstract class LeaseRepository {
  Future<Either<Failure, LeaseEntity>> getLeaseById(int leaseId);
  Future<Either<Failure, List<LeaseEntity>>> getAllLeases();
  Future<Either<Failure, List<LeaseEntity>>> getLeasesByUnitId(int unitId);
  Future<Either<Failure, List<LeaseEntity>>> getLeasesByTenantId(int tenantId);
  Future<Either<Failure, List<LeaseEntity>>> getActiveLeases();
  Future<Either<Failure, int>> addLease(LeaseEntity lease);
  Future<Either<Failure, Unit>> updateLease(LeaseEntity lease);
  Future<Either<Failure, Unit>> deleteLease(int leaseId);
}
