import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/tenant_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/tenant_repository.dart';
import 'package:logger/logger.dart';

class AddTenantUseCase {
  final TenantRepository tenantRepository;
  final Logger _logger = Logger();

  AddTenantUseCase(this.tenantRepository);

  Future<Either<Failure, int>> call(TenantEntity tenant) async {
    if (tenant.fullName.isEmpty) {
      _logger.e('Tenant name cannot be empty via AddTenantUseCase.');
      return Left(
        ValidationFailure('Tenant name cannot be empty via AddTenantUseCase.'),
      );
    }
    return await tenantRepository.addTenant(tenant);
  }
}
