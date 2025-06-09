import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/scheduled_payment_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/scheduled_payment_repository.dart';

class UpdateScheduledPaymentUseCase {
  final ScheduledPaymentRepository repository;
  UpdateScheduledPaymentUseCase(this.repository);
  Future<Either<Failure, Unit>> call(ScheduledPaymentEntity payment) async {
    if (payment.scheduledPaymentId == null) {
      return Left(
        ValidationFailure('Scheduled payment ID cannot be null for update.'),
      );
    }
    // Add more validation as needed (e.g., amountPaidSoFar <= amountDue)
    return await repository.updateScheduledPayment(payment);
  }
}
