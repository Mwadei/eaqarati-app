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
