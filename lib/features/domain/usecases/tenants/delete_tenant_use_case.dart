import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/repositories/tenant_repository.dart';

class DeleteTenantUseCase {
  final TenantRepository tenantRepository;

  DeleteTenantUseCase(this.tenantRepository);

  Future<Either<Failure, Unit>> call(int tenantId) async {
    return await tenantRepository.deleteTenant(tenantId);
  }
}
