import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/scheduled_payment_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/scheduled_payment_repository.dart';
import 'package:sqflite/sqflite.dart';

class AddScheduledPaymentsBatchUseCase {
  final ScheduledPaymentRepository repository;
  AddScheduledPaymentsBatchUseCase(this.repository);
  Future<Either<Failure, List<int>>> call(
    List<ScheduledPaymentEntity> payments, {
    Transaction? transaction,
  }) async {
    if (payments.isEmpty) {
      return Left(
        ValidationFailure('Payment list cannot be empty for batch add.'),
      );
    }
    if (payments.any((p) => p.amountDue <= 0)) {
      return Left(
        ValidationFailure(
          'All payments in batch must have positive amount due.',
        ),
      );
    }
    return await repository.addScheduledPaymentsBatch(
      payments,
      transaction: transaction,
    );
  }
}
