import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/financial_statement_entry.dart';
import 'package:eaqarati_app/features/domain/entities/lease_entity.dart';
import 'package:eaqarati_app/features/domain/entities/property_entity.dart';
import 'package:eaqarati_app/features/domain/entities/scheduled_payment_entity.dart';
import 'package:eaqarati_app/features/domain/entities/tenant_entity.dart';
import 'package:eaqarati_app/features/domain/entities/units_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/lease_repository.dart';
import 'package:eaqarati_app/features/domain/repositories/property_repository.dart';
import 'package:eaqarati_app/features/domain/repositories/scheduled_payment_repository.dart';
import 'package:eaqarati_app/features/domain/repositories/tenant_repository.dart';
import 'package:eaqarati_app/features/domain/repositories/units_repository.dart';
import 'package:logger/logger.dart';

class GenerateAnnualFinancialStatementUseCase {
  final PropertyRepository propertyRepository;
  final UnitsRepository unitsRepository;
  final LeaseRepository leaseRepository;
  final TenantRepository tenantRepository;
  final ScheduledPaymentRepository scheduledPaymentRepository;
  final Logger _logger = Logger();

  GenerateAnnualFinancialStatementUseCase({
    required this.propertyRepository,
    required this.unitsRepository,
    required this.leaseRepository,
    required this.tenantRepository,
    required this.scheduledPaymentRepository,
  });

  Future<Either<Failure, List<FinancialStatementEntry>>> call({
    required int propertyId,
    required int year,
  }) async {
    try {
      final List<FinancialStatementEntry> statementEntries = [];
      final yearStart = DateTime(year, 1, 1);
      final yearEnd = DateTime(year, 12, 31, 23, 59, 59);

      final propertyResult = await propertyRepository.getPropertyById(
        propertyId,
      );
      if (propertyResult.isLeft()) {
        return Left(propertyResult.fold((l) => l, (r) => null)!);
      }

      final propertyName = propertyResult.getOrElse(
        () => PropertyEntity(
          propertyId: propertyId,
          name: '',
          address: '',
          type: '',
          notes: '',
          createdAt: DateTime.now(),
        ),
      );

      final unitsResult = await unitsRepository.getUnitsByPropertyId(
        propertyId,
      );
      if (unitsResult.isLeft()) {
        return Left(unitsResult.fold((l) => l, (r) => null)!);
      }
      final units = unitsResult.getOrElse(() => []);

      for (UnitsEntity unit in units) {
        final leasesResult = await leaseRepository.getLeasesByUnitId(
          unit.unitId!,
        );
        if (leasesResult.isLeft()) {
          _logger.w(
            "Failed to get leases for unit ${unit.unitId}: ${leasesResult.fold((l) => l.message, (_) => '')}",
          );
          continue; // Skip this unit or handle error
        }
        final allLeasesForUnit = leasesResult.getOrElse(() => []);

        // Filter leases active within the specified year
        final relevantLeases = allLeasesForUnit.where((lease) {
          return lease.startDate.isBefore(yearEnd) &&
              lease.endDate.isAfter(yearStart);
        });

        for (LeaseEntity lease in relevantLeases) {
          String? tenantName = "N/A";

          // Get tenant name
          final tenantResult = await tenantRepository.getTenantById(
            lease.tenantId,
          );
          if (tenantResult.isRight()) {
            tenantName =
                tenantResult
                    .getOrElse(
                      () =>
                          TenantEntity(fullName: '', createdAt: DateTime.now()),
                    )
                    .fullName;
          } else {
            _logger.w(
              "Failed to get tenant ${lease.tenantId} for lease ${lease.leaseId}",
            );
          }

          // Get Scheduled Payments for each Lease
          final scheduledPaymentsResult = await scheduledPaymentRepository
              .getScheduledPaymentsByLeaseId(lease.leaseId!);

          if (scheduledPaymentsResult.isLeft()) {
            _logger.w(
              "Failed to get scheduled payments for lease ${lease.leaseId}: ${scheduledPaymentsResult.fold((l) => l.message, (_) => '')}",
            );
            continue; // Skip this lease's payments or handle error
          }
          final allScheduledPaymentsForLease = scheduledPaymentsResult
              .getOrElse(() => []);

          // Filter scheduled payments whose due date is within the specified year
          final relevantScheduledPayments =
              allScheduledPaymentsForLease.where((sp) {
                return sp.dueDate.year == year;
              }).toList();

          for (ScheduledPaymentEntity sp in relevantScheduledPayments) {
            statementEntries.add(
              FinancialStatementEntry(
                propertyName: propertyName.name,
                unitNumber: unit.unitNumber,
                periodStartDate: sp.periodStartDate,
                periodEndDate: sp.periodEndDate,
                amountDue: sp.amountDue,
                amountPaidSoFar: sp.amountPaidSoFar,
                status: sp.status,
                leaseId: lease.leaseId,
                tenantId: lease.leaseId,
                tenantName: tenantName,
              ),
            );
          }
        }
      }

      // Sort entries if needed, e.g., by unit number, then by period start date
      statementEntries.sort((a, b) {
        int unitCompare = a.unitNumber.compareTo(b.unitNumber);
        if (unitCompare != 0) return unitCompare;
        return a.periodStartDate.compareTo(b.periodStartDate);
      });
      return Right(statementEntries);
    } catch (e) {
      _logger.e("Error generating financial statement: $e");
      if (e is Failure) return Left(e);
      return Left(
        ServerFailure(
          "An unexpected error occurred while generating the statement: ${e.toString()}",
        ),
      );
    }
  }
}
