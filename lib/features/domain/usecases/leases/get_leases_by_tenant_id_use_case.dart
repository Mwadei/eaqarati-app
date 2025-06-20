import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/lease_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/lease_repository.dart';

class GetLeasesByTenantIdUseCase {
  final LeaseRepository leaseRepository;
  GetLeasesByTenantIdUseCase(this.leaseRepository);
  Future<Either<Failure, List<LeaseEntity>>> call(int tenantId) async {
    return await leaseRepository.getLeasesByTenantId(tenantId);
  }
}
