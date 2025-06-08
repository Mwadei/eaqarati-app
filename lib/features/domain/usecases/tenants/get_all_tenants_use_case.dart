import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/tenant_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/tenant_repository.dart';

class GetAllTenantsUseCase {
  final TenantRepository tenantRepository;

  GetAllTenantsUseCase(this.tenantRepository);

  Future<Either<Failure, List<TenantEntity>>> call() async {
    return await tenantRepository.getAllTenants();
  }
}
