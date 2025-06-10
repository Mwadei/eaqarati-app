import 'package:eaqarati_app/features/data/sources/local/database_helper.dart';
import 'package:eaqarati_app/features/domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    super.paymentId,
    super.scheduledPaymentId,
    required super.leaseId,
    required super.tenantId,
    required super.paymentDate,
    required super.amountPaid,
    super.paymentMethod,
    super.receiptImagePath,
    super.notes,
    required super.createdAt,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      paymentId: map[DatabaseHelper.colPaymentId] as int?,
      scheduledPaymentId:
          map[DatabaseHelper.colPaymentScheduledPaymentId] as int?,
      leaseId: map[DatabaseHelper.colPaymentLeaseId] as int,
      tenantId: map[DatabaseHelper.colPaymentTenantId] as int,
      paymentDate: DateTime.parse(map[DatabaseHelper.colPaymentDate] as String),
      amountPaid: map[DatabaseHelper.colPaymentAmountPaid] as double,
      paymentMethod: map[DatabaseHelper.colPaymentMethod] as String?,
      receiptImagePath:
          map[DatabaseHelper.colPaymentReceiptImagePath] as String?,
      notes: map[DatabaseHelper.colPaymentNotes] as String?,
      createdAt: DateTime.parse(
        map[DatabaseHelper.colPaymentCreatedAt] as String,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (paymentId != null) DatabaseHelper.colPaymentId: paymentId,
      DatabaseHelper.colPaymentScheduledPaymentId: scheduledPaymentId,
      DatabaseHelper.colPaymentLeaseId: leaseId,
      DatabaseHelper.colPaymentTenantId: tenantId,
      DatabaseHelper.colPaymentDate: paymentDate.toIso8601String(),
      DatabaseHelper.colPaymentAmountPaid: amountPaid,
      DatabaseHelper.colPaymentMethod: paymentMethod,
      DatabaseHelper.colPaymentReceiptImagePath: receiptImagePath,
      DatabaseHelper.colPaymentNotes: notes,
      DatabaseHelper.colPaymentCreatedAt: createdAt.toIso8601String(),
    };
  }

  PaymentModel copyWith({
    int? paymentId,
    int? scheduledPaymentId,
    int? leaseId,
    int? tenantId,
    DateTime? paymentDate,
    double? amountPaid,
    String? paymentMethod,
    String? receiptImagePath,
    String? notes,
    DateTime? createdAt,
  }) {
    return PaymentModel(
      paymentId: paymentId ?? this.paymentId,
      scheduledPaymentId: scheduledPaymentId ?? this.scheduledPaymentId,
      leaseId: leaseId ?? this.leaseId,
      tenantId: tenantId ?? this.tenantId,
      paymentDate: paymentDate ?? this.paymentDate,
      amountPaid: amountPaid ?? this.amountPaid,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      receiptImagePath: receiptImagePath ?? this.receiptImagePath,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
