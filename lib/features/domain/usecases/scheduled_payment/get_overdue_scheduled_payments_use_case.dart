import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/scheduled_payment_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/scheduled_payment_repository.dart';

class GetOverdueScheduledPaymentsUseCase {
  final ScheduledPaymentRepository repository;
  GetOverdueScheduledPaymentsUseCase(this.repository);
  // Pass current date to ensure consistency in "overdue" definition
  Future<Either<Failure, List<ScheduledPaymentEntity>>> call({
    DateTime? currentDate,
  }) async {
    return await repository.getOverdueScheduledPayments(
      currentDate ?? DateTime.now(),
    );
  }
}
