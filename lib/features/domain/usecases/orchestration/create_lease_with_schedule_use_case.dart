import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/core/services/payment_schedule_service.dart';
import 'package:eaqarati_app/features/data/sources/local/database_helper.dart';
import 'package:eaqarati_app/features/domain/entities/lease_entity.dart';
import 'package:eaqarati_app/features/domain/entities/scheduled_payment_entity.dart';
import 'package:eaqarati_app/features/domain/usecases/leases/add_lease_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/scheduled_payment/add_scheduled_payments_batch_use_case.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class CreateLeaseWithScheduleUseCase {
  final AddLeaseUseCase addLeaseUseCase;
  final PaymentScheduleService paymentScheduleService;
  final AddScheduledPaymentsBatchUseCase addScheduledPaymentsBatchUseCase;
  final DatabaseHelper databaseHelper;
  final Logger _logger = Logger();

  CreateLeaseWithScheduleUseCase({
    required this.addLeaseUseCase,
    required this.paymentScheduleService,
    required this.addScheduledPaymentsBatchUseCase,
    required this.databaseHelper,
  });

  Future<Either<Failure, int>> call(LeaseEntity leaseToCreate) async {
    final Database db = await databaseHelper.database;

    try {
      return await db.transaction((txn) async {
        final leaseIdResult = await addLeaseUseCase.call(
          leaseToCreate,
          transaction: txn,
        );

        return await leaseIdResult.fold(
          (failure) {
            _logger.e(
              "Failed to add lease within transaction: ${failure.message}",
            );
            throw failure; // Propagate failure to trigger rollback
          },
          (newLeaseId) async {
            _logger.i("Lease added with ID: $newLeaseId within transaction.");

            final LeaseEntity createdLeaseWithId = leaseToCreate.copyWith(
              leaseId: newLeaseId,
            );

            // generate scheduled payments
            final List<ScheduledPaymentEntity> installments =
                paymentScheduleService.generateScheduledPaymentsForLease(
                  createdLeaseWithId,
                );

            if (installments.isNotEmpty) {
              _logger.i(
                "Generated ${installments.length} installments for lease ID: $newLeaseId.",
              );

              final batchResult = await addScheduledPaymentsBatchUseCase.call(
                installments,
                transaction: txn,
              );

              return batchResult.fold(
                (batchFailure) {
                  _logger.e(
                    "Failed to add scheduled payments batch: ${batchFailure.message}",
                  );
                  throw batchFailure; // Propagate failure
                },
                (ids) {
                  _logger.i(
                    "Successfully added ${ids.length} scheduled payments for lease ID: $newLeaseId.",
                  );
                  return Right<Failure, int>(newLeaseId);
                },
              );
            } else {
              _logger.i("No installments generated for lease ID: $newLeaseId.");
              return Right<Failure, int>(newLeaseId);
            }
          },
        );
      });
    } catch (e) {
      _logger.e("Transaction failed for creating lease with schedule: $e");
      if (e is Failure) {
        return Left(e);
      }
      return Left(
        DatabaseFailure(
          "Transaction failed while creating lease: ${e.toString()}",
        ),
      );
    }
  }
}
