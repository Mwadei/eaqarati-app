import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/scheduled_payment_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/scheduled_payment_repository.dart';

class GetUpcomingScheduledPaymentsUseCase {
  final ScheduledPaymentRepository scheduledPaymentRepository;

  GetUpcomingScheduledPaymentsUseCase(this.scheduledPaymentRepository);

  Future<Either<Failure, List<ScheduledPaymentEntity>>> call({
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    if (fromDate.isAfter(toDate)) {
      return Left(ValidationFailure("From date cannot be after to date."));
    }
    return await scheduledPaymentRepository.getUpcomingScheduledPayments(
      fromDate,
      toDate,
    );
  }
}
