import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/scheduled_payment_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/scheduled_payment_repository.dart';

class GetScheduledPaymentsByLeaseIdUseCase {
  final ScheduledPaymentRepository repository;
  GetScheduledPaymentsByLeaseIdUseCase(this.repository);
  Future<Either<Failure, List<ScheduledPaymentEntity>>> call(
    int leaseId,
  ) async {
    return await repository.getScheduledPaymentsByLeaseId(leaseId);
  }
}
