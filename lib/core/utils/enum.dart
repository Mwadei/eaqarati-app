enum SettingType { language, theme }

enum UnitStatus { vacant, occupied, underMaintenance }

enum PaymentFrequencyType {
  daily,
  weekly,
  monthly,
  quarterly,
  semiAnnually,
  annually,
  customDays,
}

extension PaymentFrequencyTypeExtension on PaymentFrequencyType {
  String get value {
    switch (this) {
      case PaymentFrequencyType.daily:
        return 'Daily';
      case PaymentFrequencyType.weekly:
        return 'Weekly';
      case PaymentFrequencyType.monthly:
        return 'Monthly';
      case PaymentFrequencyType.quarterly:
        return 'Quarterly';
      case PaymentFrequencyType.semiAnnually:
        return 'SemiAnnually';
      case PaymentFrequencyType.annually:
        return 'Annually';
      case PaymentFrequencyType.customDays:
        return 'Custom_Days';
    }
  }

  static PaymentFrequencyType fromString(String? typeString) {
    switch (typeString) {
      case 'Daily':
        return PaymentFrequencyType.daily;
      case 'Weekly':
        return PaymentFrequencyType.weekly;
      case 'Monthly':
        return PaymentFrequencyType.monthly;
      case 'Quarterly':
        return PaymentFrequencyType.quarterly;
      case 'SemiAnnually':
        return PaymentFrequencyType.semiAnnually;
      case 'Annually':
        return PaymentFrequencyType.annually;
      case 'Custom_Days':
        return PaymentFrequencyType.customDays;
      default:
        return PaymentFrequencyType.monthly;
    }
  }
}

enum ScheduledPaymentStatus {
  pending,
  partiallyPaid,
  paid,
  overdue,
  cancelled, // Optional: if a lease is terminated early, etc.
}

extension ScheduledPaymentStatusExtension on ScheduledPaymentStatus {
  String get value {
    switch (this) {
      case ScheduledPaymentStatus.pending:
        return 'Pending';
      case ScheduledPaymentStatus.partiallyPaid:
        return 'Partially Paid';
      case ScheduledPaymentStatus.paid:
        return 'Paid';
      case ScheduledPaymentStatus.overdue:
        return 'Overdue';
      case ScheduledPaymentStatus.cancelled:
        return 'Cancelled';
    }
  }

  static ScheduledPaymentStatus fromString(String? statusString) {
    switch (statusString) {
      case 'Pending':
        return ScheduledPaymentStatus.pending;
      case 'Partially Paid':
        return ScheduledPaymentStatus.partiallyPaid;
      case 'Paid':
        return ScheduledPaymentStatus.paid;
      case 'Overdue':
        return ScheduledPaymentStatus.overdue;
      case 'Cancelled':
        return ScheduledPaymentStatus.cancelled;
      default:
        return ScheduledPaymentStatus.pending; // Default
    }
  }
}

enum ActivityType { payment, lease, maintenance }

enum ReminderType { rent, renewal }
