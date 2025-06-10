import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/core/services/payment_schedule_service.dart';
import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:eaqarati_app/features/data/sources/local/database_helper.dart';
import 'package:eaqarati_app/features/domain/entities/payment_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/payment_repository.dart';
import 'package:eaqarati_app/features/domain/repositories/scheduled_payment_repository.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class RecordPaymentUseCase {
  final PaymentRepository paymentRepository;
  final ScheduledPaymentRepository scheduledPaymentRepository;
  final DatabaseHelper databaseHelper;
  final Logger _logger = Logger();

  RecordPaymentUseCase({
    required this.paymentRepository,
    required this.scheduledPaymentRepository,
    required this.databaseHelper,
  });

  Future<Either<Failure, int>> call(PaymentEntity payment) async {
    if (payment.amountPaid <= 0) {
      return Left(ValidationFailure("Payment amount must be positive."));
    }

    final Database db = await databaseHelper.database;

    try {
      return await db.transaction((txn) async {
        final addPaymentResult = await paymentRepository.addPayment(
          payment,
          transaction: txn,
        );

        return await addPaymentResult.fold(
          (failure) {
            _logger.e("Failed to record payment: ${failure.message}");
            throw failure;
          },
          (paymentId) async {
            _logger.i("Payment recorded with ID: $paymentId");

            if (payment.scheduledPaymentId != null) {
              final scheduledPaymentResult = await scheduledPaymentRepository
                  .getScheduledPaymentById(payment.scheduledPaymentId!);

              return await scheduledPaymentResult.fold(
                (schFailure) {
                  _logger.e(
                    "Failed to fetch scheduled payment ${payment.scheduledPaymentId} for update: ${schFailure.message}",
                  );
                  throw schFailure;
                },
                (scheduledPayment) async {
                  double newAmountPaidSoFar =
                      scheduledPayment.amountPaidSoFar + payment.amountPaid;
                  ScheduledPaymentStatus newStatus = scheduledPayment.status;

                  if (newAmountPaidSoFar >= scheduledPayment.amountDue) {
                    newStatus = ScheduledPaymentStatus.paid;
                  } else if (newAmountPaidSoFar > 0) {
                    newStatus = ScheduledPaymentStatus.partiallyPaid;
                  }

                  final updatedScheduledPayment = scheduledPayment.copyWith(
                    amountPaidSoFar: newAmountPaidSoFar,
                    status: newStatus,
                  );

                  final updateScheduleResult = await scheduledPaymentRepository
                      .updateScheduledPayment(
                        updatedScheduledPayment,
                        transaction: txn,
                      );

                  return await updateScheduleResult.fold(
                    (updSchFailure) {
                      _logger.e(
                        "Failed to update scheduled payment ${payment.scheduledPaymentId}: ${updSchFailure.message}",
                      );
                      throw updSchFailure;
                    },
                    (_) {
                      _logger.i(
                        "Scheduled payment ${payment.scheduledPaymentId} updated successfully.",
                      );
                      return Right<Failure, int>(paymentId);
                    },
                  );
                },
              );
            } else {
              _logger.i(
                "Payment $paymentId recorded (not linked to a specific schedule).",
              );
              return Right<Failure, int>(paymentId);
            }
          },
        );
      });
    } catch (e) {
      _logger.e("Transaction failed for recording payment: $e");
      if (e is Failure) {
        return Left(e);
      }
      return Left(
        DatabaseFailure(
          "Transaction failed while recording payment: ${e.toString()}",
        ),
      );
    }
  }
}
