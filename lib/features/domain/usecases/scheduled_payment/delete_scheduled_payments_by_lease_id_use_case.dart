import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/repositories/scheduled_payment_repository.dart';
import 'package:sqflite/sqflite.dart';

class DeleteScheduledPaymentsByLeaseIdUseCase {
  final ScheduledPaymentRepository repository;
  DeleteScheduledPaymentsByLeaseIdUseCase(this.repository);
  Future<Either<Failure, Unit>> call(
    int leaseId, {
    Transaction? transaction,
  }) async {
    return await repository.deleteScheduledPaymentsByLeaseId(
      leaseId,
      transaction: transaction,
    );
  }
}
