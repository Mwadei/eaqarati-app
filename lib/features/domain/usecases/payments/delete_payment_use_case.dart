import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/core/services/payment_schedule_service.dart';
import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:eaqarati_app/features/data/sources/local/database_helper.dart';
import 'package:eaqarati_app/features/domain/repositories/payment_repository.dart';
import 'package:eaqarati_app/features/domain/repositories/scheduled_payment_repository.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class DeletePaymentUseCase {
  final PaymentRepository paymentRepository;
  final ScheduledPaymentRepository scheduledPaymentRepository;
  final DatabaseHelper databaseHelper;
  final Logger _logger = Logger();

  DeletePaymentUseCase({
    required this.paymentRepository,
    required this.scheduledPaymentRepository,
    required this.databaseHelper,
  });

  Future<Either<Failure, Unit>> call(int paymentIdToDelete) async {
    final sqflite.Database db = await databaseHelper.database;
    try {
      return await db.transaction((txn) async {
        final paymentResult = await paymentRepository.getPaymentById(
          paymentIdToDelete,
        );

        return await paymentResult.fold(
          (failure) {
            _logger.e(
              "Payment to delete (ID: $paymentIdToDelete) not found: ${failure.message}",
            );
            throw failure;
          },
          (paymentToDelete) async {
            final deleteResult = await paymentRepository.deletePayment(
              paymentIdToDelete,
              transaction: txn,
            );

            return await deleteResult.fold(
              (delFailure) {
                _logger.e(
                  "Failed to delete payment ID $paymentIdToDelete: ${delFailure.message}",
                );
                throw delFailure;
              },
              (_) async {
                _logger.i("Payment ID $paymentIdToDelete deleted.");
                if (paymentToDelete.scheduledPaymentId != null) {
                  final schPaymentResult = await scheduledPaymentRepository
                      .getScheduledPaymentById(
                        paymentToDelete.scheduledPaymentId!,
                      );

                  return await schPaymentResult.fold(
                    (schFail) {
                      _logger.w(
                        "Could not find scheduled payment ${paymentToDelete.scheduledPaymentId} to revert status. Payment deleted anyway.",
                      );
                      return Right<Failure, Unit>(unit);
                    },
                    (scheduledPayment) async {
                      double newAmountPaidSoFar =
                          scheduledPayment.amountPaidSoFar -
                          paymentToDelete.amountPaid;

                      ScheduledPaymentStatus newStatus =
                          ScheduledPaymentStatus.pending;
                      if (newAmountPaidSoFar >= scheduledPayment.amountDue) {
                        newStatus = ScheduledPaymentStatus.paid;
                      } else if (newAmountPaidSoFar > 0) {
                        newStatus = ScheduledPaymentStatus.partiallyPaid;
                      }

                      final revertedScheduledPayment = scheduledPayment
                          .copyWith(
                            amountPaidSoFar: newAmountPaidSoFar,
                            status: newStatus,
                          );
                      final updateSchResult = await scheduledPaymentRepository
                          .updateScheduledPayment(
                            revertedScheduledPayment,
                            transaction: txn,
                          );

                      return updateSchResult.fold((updFail) {
                        _logger.e(
                          "Failed to revert scheduled payment ${scheduledPayment.scheduledPaymentId}: ${updFail.message}",
                        );
                        throw updFail;
                      }, (_) => Right<Failure, Unit>(unit));
                    },
                  );
                }
                return Right<Failure, Unit>(unit);
              },
            );
          },
        );
      });
    } catch (e) {
      _logger.e("Transaction failed for deleting payment: $e");
      if (e is Failure) return Left(e);
      return Left(
        DatabaseFailure(
          "Transaction failed while deleting payment: ${e.toString()}",
        ),
      );
    }
  }
}
