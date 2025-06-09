import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/scheduled_payment_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/scheduled_payment_repository.dart';

class GetScheduledPaymentByStatus {
  final ScheduledPaymentRepository repository;
  GetScheduledPaymentByStatus(this.repository);
  Future<Either<Failure, List<ScheduledPaymentEntity>>> call(
    String status,
  ) async {
    return await repository.getScheduledPaymentsByStatus(status);
  }
}
