import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/payment_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

abstract class PaymentRepository {
  Future<Either<Failure, PaymentEntity>> getPaymentById(int id);
  Future<Either<Failure, List<PaymentEntity>>> getAllPayments();
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByLeaseId(
    int leaseId,
  );
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByTenantId(
    int tenantId,
  );
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByScheduledPaymentId(
    int scheduledPaymentId,
  );
  Future<Either<Failure, int>> addPayment(
    PaymentEntity payment, {
    sqflite.Transaction? transaction,
  });
  Future<Either<Failure, Unit>> updatePayment(
    PaymentEntity payment, {
    sqflite.Transaction? transaction,
  });
  Future<Either<Failure, Unit>> deletePayment(
    int id, {
    sqflite.Transaction? transaction,
  });
}
