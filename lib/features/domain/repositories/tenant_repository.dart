import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/tenant_entity.dart';

abstract class TenantRepository {
  Future<Either<Failure, TenantEntity>> getTenantById(int tenantId);
  Future<Either<Failure, List<TenantEntity>>> getAllTenants();
  Future<Either<Failure, int>> addTenant(TenantEntity tenant);
  Future<Either<Failure, Unit>> updateTenant(TenantEntity tenant);
  Future<Either<Failure, Unit>> deleteTenant(int tenantId);
}
