import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/data/models/payment_model.dart';
import 'package:eaqarati_app/features/data/sources/local/payment_local_data_source.dart';
import 'package:eaqarati_app/features/domain/entities/payment_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/payment_repository.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentLocalDataSource localDataSource;
  final Logger _logger = Logger();

  PaymentRepositoryImpl({required this.localDataSource});

  PaymentModel _toModel(PaymentEntity entity) {
    return PaymentModel(
      paymentId: entity.paymentId,
      scheduledPaymentId: entity.scheduledPaymentId,
      leaseId: entity.leaseId,
      tenantId: entity.tenantId,
      paymentDate: entity.paymentDate,
      amountPaid: entity.amountPaid,
      paymentMethod: entity.paymentMethod,
      receiptImagePath: entity.receiptImagePath,
      notes: entity.notes,
      createdAt: entity.createdAt,
    );
  }

  @override
  Future<Either<Failure, int>> addPayment(
    PaymentEntity payment, {
    sqflite.Transaction? transaction,
  }) async {
    try {
      final model = _toModel(payment);
      if (model.paymentId != null) {
        return Left(
          DatabaseFailure('Payment ID must be null for new payment.'),
        );
      }
      final id = await localDataSource.addPayment(model, txn: transaction);
      return Right(id);
    } on sqflite.DatabaseException catch (e) {
      _logger.e('DBException adding payment: ${e.toString()}');
      return Left(DatabaseFailure('Failed to add payment: ${e.toString()}'));
    } catch (e) {
      _logger.e('Error adding payment: ${e.toString()}');
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePayment(
    int id, {
    sqflite.Transaction? transaction,
  }) async {
    try {
      final count = await localDataSource.deletePayment(id, txn: transaction);
      if (count > 0) {
        return Right(unit);
      } else {
        return Left(NotFoundFailure('Payment with ID $id not found.'));
      }
    } on sqflite.DatabaseException catch (e) {
      _logger.e('DBException deleting payment: ${e.toString()}');
      return Left(DatabaseFailure('Failed to delete payment: ${e.toString()}'));
    } catch (e) {
      _logger.e('Error deleting payment: ${e.toString()}');
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getAllPayments() async {
    try {
      final models = await localDataSource.getAllPayments();
      return Right(models.map((m) => m as PaymentEntity).toList());
    } on sqflite.DatabaseException catch (e) {
      _logger.e('DBException getting all payments: ${e.toString()}');
      return Left(
        DatabaseFailure('Failed to get all payments: ${e.toString()}'),
      );
    } catch (e) {
      _logger.e('Error getting all payments: ${e.toString()}');
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> getPaymentById(int id) async {
    try {
      final model = await localDataSource.getPaymentById(id);
      if (model != null) {
        return Right(model as PaymentEntity);
      } else {
        return Left(NotFoundFailure('Payment with ID $id not found.'));
      }
    } on sqflite.DatabaseException catch (e) {
      _logger.e('DBException getting payment by ID $id: ${e.toString()}');
      return Left(DatabaseFailure('Failed to get payment: ${e.toString()}'));
    } catch (e) {
      _logger.e('Error getting payment by ID $id: ${e.toString()}');
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByLeaseId(
    int leaseId,
  ) async {
    try {
      final models = await localDataSource.getPaymentsByLeaseId(leaseId);
      return Right(models.map((m) => m as PaymentEntity).toList());
    } on sqflite.DatabaseException catch (e) {
      _logger.e(
        'DBException getting payments for lease $leaseId: ${e.toString()}',
      );
      return Left(
        DatabaseFailure('Failed to get payments for lease: ${e.toString()}'),
      );
    } catch (e) {
      _logger.e('Error getting payments for lease $leaseId: ${e.toString()}');
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByTenantId(
    int tenantId,
  ) async {
    try {
      final models = await localDataSource.getPaymentsByTenantId(tenantId);
      return Right(models.map((m) => m as PaymentEntity).toList());
    } on sqflite.DatabaseException catch (e) {
      _logger.e(
        'DBException getting payments for tenant $tenantId: ${e.toString()}',
      );
      return Left(
        DatabaseFailure('Failed to get payments for tenant: ${e.toString()}'),
      );
    } catch (e) {
      _logger.e('Error getting payments for tenant $tenantId: ${e.toString()}');
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByScheduledPaymentId(
    int scheduledPaymentId,
  ) async {
    try {
      final models = await localDataSource.getPaymentsByScheduledPaymentId(
        scheduledPaymentId,
      );
      return Right(models.map((m) => m as PaymentEntity).toList());
    } on sqflite.DatabaseException catch (e) {
      _logger.e(
        'DBException getting payments for scheduled_payment_id $scheduledPaymentId: ${e.toString()}',
      );
      return Left(
        DatabaseFailure(
          'Failed to get payments for scheduled_payment_id: ${e.toString()}',
        ),
      );
    } catch (e) {
      _logger.e(
        'Error getting payments for scheduled_payment_id $scheduledPaymentId: ${e.toString()}',
      );
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePayment(
    PaymentEntity payment, {
    sqflite.Transaction? transaction,
  }) async {
    try {
      if (payment.paymentId == null) {
        return Left(DatabaseFailure('Payment ID cannot be null for update.'));
      }
      final model = _toModel(payment);
      final count = await localDataSource.updatePayment(
        model,
        txn: transaction,
      );
      if (count > 0) {
        return Right(unit);
      } else {
        return Left(
          NotFoundFailure(
            'Payment with ID ${payment.paymentId} not found or no data changed.',
          ),
        );
      }
    } on sqflite.DatabaseException catch (e) {
      _logger.e('DBException updating payment: ${e.toString()}');
      return Left(DatabaseFailure('Failed to update payment: ${e.toString()}'));
    } catch (e) {
      _logger.e('Error updating payment: ${e.toString()}');
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }
}
