import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/core/services/payment_schedule_service.dart';
import 'package:eaqarati_app/features/data/sources/local/database_helper.dart';
import 'package:eaqarati_app/features/domain/entities/lease_entity.dart';
import 'package:eaqarati_app/features/domain/entities/scheduled_payment_entity.dart';
import 'package:eaqarati_app/features/domain/usecases/leases/update_lease_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/scheduled_payment/add_scheduled_payments_batch_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/scheduled_payment/delete_scheduled_payments_by_lease_id_use_case.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class UpdateLeaseWithScheduleUseCase {
  final UpdateLeaseUseCase updateLeaseUseCase;
  final DeleteScheduledPaymentsByLeaseIdUseCase
  deleteScheduledPaymentsByLeaseIdUseCase;
  final PaymentScheduleService paymentScheduleService;
  final AddScheduledPaymentsBatchUseCase addScheduledPaymentsBatchUseCase;
  final DatabaseHelper databaseHelper;
  final Logger _logger = Logger();

  UpdateLeaseWithScheduleUseCase({
    required this.updateLeaseUseCase,
    required this.deleteScheduledPaymentsByLeaseIdUseCase,
    required this.paymentScheduleService,
    required this.addScheduledPaymentsBatchUseCase,
    required this.databaseHelper,
  });

  Future<Either<Failure, Unit>> call(LeaseEntity leaseToUpdate) async {
    if (leaseToUpdate.leaseId == null) {
      return Left(ValidationFailure("Lease ID is required for update."));
    }

    final Database db = await databaseHelper.database;

    try {
      return await db.transaction((txn) async {
        final deleteResult = await deleteScheduledPaymentsByLeaseIdUseCase.call(
          leaseToUpdate.leaseId!,
          transaction: txn,
        );

        return await deleteResult.fold(
          (failure) {
            _logger.e(
              "Failed to delete old scheduled payments for lease ${leaseToUpdate.leaseId}: ${failure.message}",
            );
            throw failure; // Propagate failure
          },
          (_) async {
            _logger.i(
              "Successfully deleted old schedules for lease ID: ${leaseToUpdate.leaseId}.",
            );

            final updateLeaseResult = await updateLeaseUseCase.call(
              leaseToUpdate,
              transaction: txn,
            );

            return await updateLeaseResult.fold(
              (updateFailure) {
                _logger.e(
                  "Failed to update lease ${leaseToUpdate.leaseId}: ${updateFailure.message}",
                );
                throw updateFailure; // Propagate failure
              },
              (_) async {
                _logger.i(
                  "Lease ID: ${leaseToUpdate.leaseId} updated successfully.",
                );

                final List<ScheduledPaymentEntity> installments =
                    paymentScheduleService.generateScheduledPaymentsForLease(
                      leaseToUpdate,
                    );

                if (installments.isNotEmpty) {
                  _logger.i(
                    "Generated ${installments.length} new installments for lease ID: ${leaseToUpdate.leaseId}.",
                  );

                  final batchResult = await addScheduledPaymentsBatchUseCase
                      .call(installments, transaction: txn);

                  return batchResult.fold(
                    (batchFailure) {
                      _logger.e(
                        "Failed to add new scheduled payments batch for lease ${leaseToUpdate.leaseId}: ${batchFailure.message}",
                      );
                      throw batchFailure; // Propagate failure
                    },
                    (_) {
                      _logger.i(
                        "Successfully added new scheduled payments for lease ID: ${leaseToUpdate.leaseId}.",
                      );
                      return Right<Failure, Unit>(unit); // Success
                    },
                  );
                } else {
                  _logger.i(
                    "No new installments generated for updated lease ID: ${leaseToUpdate.leaseId}.",
                  );
                  return Right<Failure, Unit>(
                    unit,
                  ); // Lease updated, no new installments
                }
              },
            );
          },
        );
      });
    } catch (e) {
      _logger.e("Transaction failed for updating lease with schedule: $e");
      if (e is Failure) {
        return Left(e);
      }
      return Left(
        DatabaseFailure(
          "Transaction failed while updating lease: ${e.toString()}",
        ),
      );
    }
  }
}
