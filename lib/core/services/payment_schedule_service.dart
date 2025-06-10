import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:eaqarati_app/features/domain/entities/lease_entity.dart';
import 'package:eaqarati_app/features/domain/entities/scheduled_payment_entity.dart';

class PaymentScheduleService {
  List<ScheduledPaymentEntity> generateScheduledPaymentsForLease(
    LeaseEntity lease,
  ) {
    final List<ScheduledPaymentEntity> schedules = [];
    if (!lease.isActive || lease.startDate.isAfter(lease.endDate)) {
      return schedules; // No payments for inactive or invalid leases
    }

    DateTime currentPeriodStart = lease.startDate;
    DateTime leaseEndDate = lease.endDate;
    int installmentNumber = 1; // For debugging or notes if needed

    // Calculate payment amount per installment based on frequency
    // This is a simplified model. For rent_amount being total for the lease period,
    // or rent_amount being per payment period, adjust logic.
    // Assuming lease.rentAmount is the amount for EACH payment period.
    double amountPerInstallment = lease.rentAmount;

    while (currentPeriodStart.isBefore(leaseEndDate) ||
        currentPeriodStart.isAtSameMomentAs(leaseEndDate)) {
      DateTime dueDate;
      DateTime periodEndDate;

      switch (lease.paymentFrequencyType) {
        case PaymentFrequencyType.daily:
          dueDate = currentPeriodStart;
          periodEndDate = currentPeriodStart;
          currentPeriodStart = DateTime(
            currentPeriodStart.year,
            currentPeriodStart.month,
            currentPeriodStart.day + 1,
          );
          break;
        case PaymentFrequencyType.weekly:
          dueDate =
              currentPeriodStart; // Or adjust if due on a specific day of the week
          periodEndDate = DateTime(
            currentPeriodStart.year,
            currentPeriodStart.month,
            currentPeriodStart.day + 6,
          );
          if (periodEndDate.isAfter(leaseEndDate)) periodEndDate = leaseEndDate;
          currentPeriodStart = DateTime(
            currentPeriodStart.year,
            currentPeriodStart.month,
            currentPeriodStart.day + 7,
          );
          break;
        case PaymentFrequencyType.monthly:
          dueDate = currentPeriodStart;
          // Calculate end of current month or lease end date
          int year = currentPeriodStart.year;
          int month = currentPeriodStart.month;
          periodEndDate = DateTime(
            year,
            month + 1,
            0,
          ); // Last day of current month
          if (periodEndDate.isAfter(leaseEndDate)) periodEndDate = leaseEndDate;
          currentPeriodStart = _createSafeDate(
            year,
            month + 1,
            lease.startDate.day,
          );

          break;
        case PaymentFrequencyType.quarterly:
          dueDate = currentPeriodStart;
          int year = currentPeriodStart.year;
          int month = currentPeriodStart.month;
          // End of the quarter (simplified: 3 months from start)
          DateTime tempPeriodEnd = _createSafeDate(
            year,
            month + 3,
            0,
          ); // Last day of the 3rd month
          periodEndDate =
              tempPeriodEnd.isAfter(leaseEndDate)
                  ? leaseEndDate
                  : tempPeriodEnd;

          currentPeriodStart = _createSafeDate(
            year,
            month + 3, // Advance by 3 months
            lease.startDate.day,
          );
          break;
        case PaymentFrequencyType.semiAnnually:
          dueDate = currentPeriodStart;
          int year = currentPeriodStart.year;
          int month = currentPeriodStart.month;
          DateTime tempPeriodEnd = _createSafeDate(year, month + 6, 0);
          periodEndDate =
              tempPeriodEnd.isAfter(leaseEndDate)
                  ? leaseEndDate
                  : tempPeriodEnd;

          currentPeriodStart = _createSafeDate(
            year,
            month + 6, // Advance by 6 months
            lease.startDate.day,
          );
          break;
        case PaymentFrequencyType.annually:
          dueDate = currentPeriodStart;
          periodEndDate = DateTime(
            currentPeriodStart.year,
            lease.endDate.month,
            lease.endDate.day,
          );
          if (periodEndDate.isAfter(leaseEndDate)) periodEndDate = leaseEndDate;

          currentPeriodStart = DateTime(
            currentPeriodStart.year + 1,
            currentPeriodStart.month,
            currentPeriodStart.day,
          );
          break;
        case PaymentFrequencyType.customDays:
          if (lease.paymentFrequencyValue == null ||
              lease.paymentFrequencyValue! <= 0) {
            // Invalid custom days, skip or throw error
            return schedules; // Or throw ArgumentError
          }
          dueDate = currentPeriodStart;
          periodEndDate = DateTime(
            currentPeriodStart.year,
            currentPeriodStart.month,
            currentPeriodStart.day + lease.paymentFrequencyValue! - 1,
          );
          if (periodEndDate.isAfter(leaseEndDate)) periodEndDate = leaseEndDate;

          currentPeriodStart = DateTime(
            currentPeriodStart.year,
            currentPeriodStart.month,
            currentPeriodStart.day + lease.paymentFrequencyValue!,
          );
          break;
      }

      // Ensure periodEndDate does not exceed leaseEndDate
      if (periodEndDate.isAfter(leaseEndDate)) {
        periodEndDate = leaseEndDate;
      }

      // Ensure dueDate is not after periodEndDate (can happen with short custom periods near end of lease)
      if (dueDate.isAfter(periodEndDate)) {
        dueDate = periodEndDate;
      }

      // Add schedule if the due date is not after the lease end date
      if (dueDate.isBefore(leaseEndDate) ||
          dueDate.isAtSameMomentAs(leaseEndDate)) {
        schedules.add(
          ScheduledPaymentEntity(
            leaseId:
                lease
                    .leaseId!, // Assume leaseId is available after lease is saved
            dueDate: dueDate,
            amountDue: amountPerInstallment,
            periodStartDate:
                schedules.isEmpty
                    ? lease.startDate
                    : schedules.last.periodEndDate.add(
                      Duration(days: 1),
                    ), // Corrected period start
            periodEndDate: periodEndDate,
            status: ScheduledPaymentStatus.pending,
            createdAt: DateTime.now(), // Or pass from calling context
          ),
        );
      } else {
        // If due date is past lease end date, we're done.
        break;
      }

      // Safety break if currentPeriodStart is not advancing or goes past lease end
      if (schedules.isNotEmpty &&
          currentPeriodStart.isBefore(schedules.last.periodEndDate)) {
        if (currentPeriodStart.isAtSameMomentAs(schedules.last.periodEndDate) &&
            currentPeriodStart.isAtSameMomentAs(leaseEndDate)) {
          // This is okay if it's the last payment and the period end is lease end
        } else {
          // Potentially stuck in a loop, or next period start is before current period end
          // This can happen with complex date logic, especially around month ends.
          // For simplicity, we'll break. A more robust solution might involve
          // setting currentPeriodStart = periodEndDate.add(Duration(days: 1));
          // _logger.w("Payment schedule generation might be stuck. Breaking.");
          break;
        }
      }
      if (currentPeriodStart.isAfter(leaseEndDate) &&
          !(currentPeriodStart.isAtSameMomentAs(leaseEndDate) &&
              periodEndDate.isAtSameMomentAs(leaseEndDate))) {
        break;
      }

      installmentNumber++;
      if (installmentNumber > 500)
        break; // Safety break for very long leases or bugs
    }

    // Adjust the periodStartDate for the first element if it was calculated based on schedules.last
    if (schedules.isNotEmpty &&
        schedules.first.periodStartDate != lease.startDate) {
      schedules[0] = schedules[0].copyWith(periodStartDate: lease.startDate);
    }

    // Final check: ensure last periodEndDate matches lease.endDate if it's the last installment
    if (schedules.isNotEmpty) {
      final lastSchedule = schedules.last;
      if (lastSchedule.periodEndDate.isBefore(lease.endDate) &&
          _isLastInstallment(
            lastSchedule,
            lease,
            lease.paymentFrequencyType,
            lease.paymentFrequencyValue,
          )) {
        schedules[schedules.length - 1] = lastSchedule.copyWith(
          periodEndDate: lease.endDate,
        );
      }
    }

    return schedules;
  }

  // Helper to determine if this is the last possible installment
  bool _isLastInstallment(
    ScheduledPaymentEntity currentSchedule,
    LeaseEntity lease,
    PaymentFrequencyType type,
    int? value,
  ) {
    DateTime nextPotentialDueDateStart;
    switch (type) {
      case PaymentFrequencyType.daily:
        nextPotentialDueDateStart = DateTime(
          currentSchedule.periodEndDate.year,
          currentSchedule.periodEndDate.month,
          currentSchedule.periodEndDate.day + 1,
        );
        break;
      case PaymentFrequencyType.weekly:
        nextPotentialDueDateStart = DateTime(
          currentSchedule.periodEndDate.year,
          currentSchedule.periodEndDate.month,
          currentSchedule.periodEndDate.day + 1,
        );
        break; // Simplified, real next start is 7 days from period start.
      case PaymentFrequencyType.monthly:
        nextPotentialDueDateStart = DateTime(
          currentSchedule.periodEndDate.year,
          currentSchedule.periodEndDate.month + 1,
          lease.startDate.day > 28
              ? _lastDayOfMonth(
                currentSchedule.periodEndDate.year,
                currentSchedule.periodEndDate.month + 1,
              )
              : lease.startDate.day,
        );
        break;
      // Add other cases if needed for more precise "last installment" check
      default:
        nextPotentialDueDateStart = currentSchedule.periodEndDate.add(
          Duration(days: 1),
        ); // Default assumption
    }
    return nextPotentialDueDateStart.isAfter(lease.endDate);
  }

  int _lastDayOfMonth(int year, int month) {
    if (month < 1 || month > 12) {
      // Correct month if it rolled over
      year += (month - 1) ~/ 12;
      month = (month - 1) % 12 + 1;
    }
    return DateTime(year, month + 1, 0).day;
  }

  // Helper to create a DateTime, ensuring day is valid for the month
  DateTime _createSafeDate(int year, int month, int day) {
    int lastDay = _lastDayOfMonth(year, month);
    return DateTime(year, month, day > lastDay ? lastDay : day);
  }
}

// Extension for ScheduledPaymentEntity to add copyWith for immutability
extension ScheduledPaymentEntityCopyWith on ScheduledPaymentEntity {
  ScheduledPaymentEntity copyWith({
    int? scheduledPaymentId,
    int? leaseId,
    DateTime? dueDate,
    double? amountDue,
    DateTime? periodStartDate,
    DateTime? periodEndDate,
    ScheduledPaymentStatus? status,
    double? amountPaidSoFar,
    DateTime? createdAt,
  }) {
    return ScheduledPaymentEntity(
      scheduledPaymentId: scheduledPaymentId ?? this.scheduledPaymentId,
      leaseId: leaseId ?? this.leaseId,
      dueDate: dueDate ?? this.dueDate,
      amountDue: amountDue ?? this.amountDue,
      periodStartDate: periodStartDate ?? this.periodStartDate,
      periodEndDate: periodEndDate ?? this.periodEndDate,
      status: status ?? this.status,
      amountPaidSoFar: amountPaidSoFar ?? this.amountPaidSoFar,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
