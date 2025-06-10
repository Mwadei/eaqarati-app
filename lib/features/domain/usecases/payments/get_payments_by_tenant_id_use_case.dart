import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/payment_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/payment_repository.dart';

class GetPaymentsByTenantIdUseCase {
  final PaymentRepository repository;
  GetPaymentsByTenantIdUseCase(this.repository);
  Future<Either<Failure, List<PaymentEntity>>> call(int tenantId) async {
    return await repository.getPaymentsByTenantId(tenantId);
  }
}
