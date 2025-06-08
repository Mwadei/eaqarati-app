import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/tenant_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/tenant_repository.dart';
import 'package:logger/web.dart';

class UpdateTenantUseCase {
  final TenantRepository tenantRepository;
  final Logger _logger = Logger();

  UpdateTenantUseCase(this.tenantRepository);

  Future<Either<Failure, Unit>> call(TenantEntity tenant) async {
    if (tenant.tenantId == null) {
      _logger.e('Tenant ID cannot be null for update via UpdateTenantUseCase.');
      return Left(
        ValidationFailure(
          'Tenant ID cannot be null for update via UpdateTenantUseCase.',
        ),
      );
    }
    if (tenant.fullName.isEmpty) {
      _logger.e(
        'Tenant name cannot be empty for update via UpdateTenantUseCase.',
      );
      return Left(
        ValidationFailure(
          'Tenant name cannot be empty for update via UpdateTenantUseCase.',
        ),
      );
    }
    return await tenantRepository.updateTenant(tenant);
  }
}
