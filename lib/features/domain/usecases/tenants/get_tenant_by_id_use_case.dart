import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/tenant_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/tenant_repository.dart';

class GetTenantByIdUseCase {
  final TenantRepository tenantRepository;

  GetTenantByIdUseCase(this.tenantRepository);

  Future<Either<Failure, TenantEntity>> call(int tenantId) async {
    return await tenantRepository.getTenantById(tenantId);
  }
}
