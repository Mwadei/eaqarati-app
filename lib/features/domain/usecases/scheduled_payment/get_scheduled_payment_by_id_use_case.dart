import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/scheduled_payment_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/scheduled_payment_repository.dart';

class GetScheduledPaymentByIdUseCase {
  final ScheduledPaymentRepository repository;
  GetScheduledPaymentByIdUseCase(this.repository);
  Future<Either<Failure, ScheduledPaymentEntity>> call(int id) async {
    return await repository.getScheduledPaymentById(id);
  }
}
