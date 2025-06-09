import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/repositories/scheduled_payment_repository.dart';

class DeleteScheduledPaymentUseCase {
  final ScheduledPaymentRepository repository;
  DeleteScheduledPaymentUseCase(this.repository);
  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deleteScheduledPayment(id);
  }
}
