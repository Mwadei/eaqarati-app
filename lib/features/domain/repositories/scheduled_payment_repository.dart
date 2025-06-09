import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/scheduled_payment_entity.dart';
import 'package:sqflite/sqflite.dart';

abstract class ScheduledPaymentRepository {
  Future<Either<Failure, ScheduledPaymentEntity>> getScheduledPaymentById(
    int id,
  );
  Future<Either<Failure, List<ScheduledPaymentEntity>>>
  getAllScheduledPayments();
  Future<Either<Failure, List<ScheduledPaymentEntity>>>
  getScheduledPaymentsByLeaseId(int leaseId);
  Future<Either<Failure, List<ScheduledPaymentEntity>>>
  getScheduledPaymentsByStatus(String status);
  Future<Either<Failure, List<ScheduledPaymentEntity>>>
  getOverdueScheduledPayments(DateTime currentDate);
  Future<Either<Failure, int>> addScheduledPayment(
    ScheduledPaymentEntity payment,
  );
  Future<Either<Failure, List<int>>> addScheduledPaymentsBatch(
    List<ScheduledPaymentEntity> payments, {
    Transaction? transaction,
  });
  Future<Either<Failure, Unit>> updateScheduledPayment(
    ScheduledPaymentEntity payment,
  );
  Future<Either<Failure, Unit>> deleteScheduledPayment(int id);
  Future<Either<Failure, Unit>> deleteScheduledPaymentsByLeaseId(
    int leaseId, {
    Transaction? transaction,
  });
}
