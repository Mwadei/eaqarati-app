import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/data/models/scheduled_payment_model.dart';
import 'package:eaqarati_app/features/data/sources/local/scheduled_payment_local_data_source.dart';
import 'package:eaqarati_app/features/domain/entities/scheduled_payment_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/scheduled_payment_repository.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class ScheduledPaymentRepositoryImpl implements ScheduledPaymentRepository {
  final ScheduledPaymentLocalDataSource localDataSource;
  final Logger _logger = Logger();

  ScheduledPaymentRepositoryImpl({required this.localDataSource});

  ScheduledPaymentModel _toModel(ScheduledPaymentEntity entity) {
    return ScheduledPaymentModel(
      scheduledPaymentId: entity.scheduledPaymentId,
      leaseId: entity.leaseId,
      dueDate: entity.dueDate,
      amountDue: entity.amountDue,
      periodStartDate: entity.periodStartDate,
      periodEndDate: entity.periodEndDate,
      status: entity.status,
      amountPaidSoFar: entity.amountPaidSoFar,
      createdAt: entity.createdAt,
    );
  }

  List<ScheduledPaymentModel> _toModelList(
    List<ScheduledPaymentEntity> entities,
  ) {
    return entities.map((e) => _toModel(e)).toList();
  }

  @override
  Future<Either<Failure, int>> addScheduledPayment(
    ScheduledPaymentEntity payment,
  ) async {
    try {
      final model = _toModel(payment);
      if (model.scheduledPaymentId != null) {
        return Left(
          DatabaseFailure('ID must be null for new scheduled payment.'),
        );
      }
      final id = await localDataSource.addScheduledPayment(model);
      return Right(id);
    } on DatabaseException catch (e) {
      _logger.e('DBException adding scheduled payment: ${e.toString()}');
      return Left(DatabaseFailure('Failed to add scheduled payment: $e'));
    } catch (e) {
      _logger.e('Error adding scheduled payment: ${e.toString()}');
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, List<int>>> addScheduledPaymentsBatch(
    List<ScheduledPaymentEntity> payments, {
    Transaction? transaction,
  }) async {
    try {
      final models = _toModelList(payments);
      if (models.any((p) => p.scheduledPaymentId != null)) {
        return Left(
          DatabaseFailure(
            'IDs must be null for new scheduled payments in batch.',
          ),
        );
      }
      final ids = await localDataSource.addScheduledPaymentsBatch(
        models,
        txn: transaction,
      );
      return Right(ids);
    } on DatabaseException catch (e) {
      _logger.e('DBException adding scheduled payments batch: ${e.toString()}');
      return Left(
        DatabaseFailure('Failed to add scheduled payments batch: $e'),
      );
    } catch (e) {
      _logger.e('Error adding scheduled payments batch: ${e.toString()}');
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteScheduledPayment(int id) async {
    try {
      final count = await localDataSource.deleteScheduledPayment(id);
      if (count > 0) {
        return Right(unit);
      } else {
        return Left(
          NotFoundFailure('Scheduled payment with ID $id not found.'),
        );
      }
    } on DatabaseException catch (e) {
      _logger.e('DBException deleting scheduled payment: ${e.toString()}');
      return Left(DatabaseFailure('Failed to delete scheduled payment: $e'));
    } catch (e) {
      _logger.e('Error deleting scheduled payment: ${e.toString()}');
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteScheduledPaymentsByLeaseId(
    int leaseId, {
    Transaction? transaction,
  }) async {
    try {
      await localDataSource.deleteScheduledPaymentsByLeaseId(
        leaseId,
        txn: transaction,
      );
      // delete operation in sqflite returns number of rows affected.
      // We don't necessarily know if any existed, but the operation itself succeeded if no error.
      return Right(unit);
    } on DatabaseException catch (e) {
      _logger.e(
        'DBException deleting scheduled payments for lease $leaseId: ${e.toString()}',
      );
      return Left(
        DatabaseFailure('Failed to delete scheduled payments for lease: $e'),
      );
    } catch (e) {
      _logger.e(
        'Error deleting scheduled payments for lease $leaseId: ${e.toString()}',
      );
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, List<ScheduledPaymentEntity>>>
  getAllScheduledPayments() async {
    try {
      final models = await localDataSource.getAllScheduledPayments();
      return Right(models.map((m) => m as ScheduledPaymentEntity).toList());
    } on DatabaseException catch (e) {
      _logger.e('DBException getting all scheduled payments: ${e.toString()}');
      return Left(DatabaseFailure('Failed to get all scheduled payments: $e'));
    } catch (e) {
      _logger.e('Error getting all scheduled payments: ${e.toString()}');
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, ScheduledPaymentEntity>> getScheduledPaymentById(
    int id,
  ) async {
    try {
      final model = await localDataSource.getScheduledPaymentById(id);
      if (model != null) {
        return Right(model as ScheduledPaymentEntity);
      } else {
        return Left(
          NotFoundFailure('Scheduled payment with ID $id not found.'),
        );
      }
    } on DatabaseException catch (e) {
      _logger.e(
        'DBException getting scheduled payment by ID $id: ${e.toString()}',
      );
      return Left(DatabaseFailure('Failed to get scheduled payment: $e'));
    } catch (e) {
      _logger.e('Error getting scheduled payment by ID $id: ${e.toString()}');
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, List<ScheduledPaymentEntity>>>
  getScheduledPaymentsByLeaseId(int leaseId) async {
    try {
      final models = await localDataSource.getScheduledPaymentsByLeaseId(
        leaseId,
      );
      return Right(models.map((m) => m as ScheduledPaymentEntity).toList());
    } on DatabaseException catch (e) {
      _logger.e(
        'DBException getting scheduled payments for lease $leaseId: ${e.toString()}',
      );
      return Left(
        DatabaseFailure('Failed to get scheduled payments for lease: $e'),
      );
    } catch (e) {
      _logger.e(
        'Error getting scheduled payments for lease $leaseId: ${e.toString()}',
      );
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, List<ScheduledPaymentEntity>>>
  getScheduledPaymentsByStatus(String status) async {
    try {
      final models = await localDataSource.getScheduledPaymentsByStatus(status);
      return Right(models.map((m) => m as ScheduledPaymentEntity).toList());
    } on DatabaseException catch (e) {
      _logger.e(
        'DBException getting scheduled payments by status $status: ${e.toString()}',
      );
      return Left(
        DatabaseFailure('Failed to get scheduled payments by status: $e'),
      );
    } catch (e) {
      _logger.e(
        'Error getting scheduled payments by status $status: ${e.toString()}',
      );
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, List<ScheduledPaymentEntity>>>
  getOverdueScheduledPayments(DateTime currentDate) async {
    try {
      final models = await localDataSource.getOverdueScheduledPayments(
        currentDate,
      );
      return Right(models.map((m) => m as ScheduledPaymentEntity).toList());
    } on DatabaseException catch (e) {
      _logger.e('DBException getting overdue payments: ${e.toString()}');
      return Left(DatabaseFailure('Failed to get overdue payments: $e'));
    } catch (e) {
      _logger.e('Error getting overdue payments: ${e.toString()}');
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateScheduledPayment(
    ScheduledPaymentEntity payment,
  ) async {
    try {
      if (payment.scheduledPaymentId == null) {
        return Left(
          DatabaseFailure('Scheduled payment ID cannot be null for update.'),
        );
      }
      final model = _toModel(payment);
      final count = await localDataSource.updateScheduledPayment(model);
      if (count > 0) {
        return Right(unit);
      } else {
        return Left(
          NotFoundFailure(
            'Scheduled payment with ID ${payment.scheduledPaymentId} not found or no data changed.',
          ),
        );
      }
    } on DatabaseException catch (e) {
      _logger.e('DBException updating scheduled payment: ${e.toString()}');
      return Left(DatabaseFailure('Failed to update scheduled payment: $e'));
    } catch (e) {
      _logger.e('Error updating scheduled payment: ${e.toString()}');
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }
}
