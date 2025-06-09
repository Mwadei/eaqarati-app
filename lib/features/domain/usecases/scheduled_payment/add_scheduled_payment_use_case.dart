import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/scheduled_payment_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/scheduled_payment_repository.dart';

class AddScheduledPaymentUseCase {
  final ScheduledPaymentRepository repository;
  AddScheduledPaymentUseCase(this.repository);
  Future<Either<Failure, int>> call(ScheduledPaymentEntity payment) async {
    // Basic validation
    if (payment.amountDue <= 0) {
      return Left(ValidationFailure('Amount due must be positive.'));
    }
    return await repository.addScheduledPayment(payment);
  }
}
