import 'package:eaqarati_app/features/data/sources/local/database_helper.dart';
import 'package:eaqarati_app/features/domain/entities/tenant_entity.dart';

class TenantModel extends TenantEntity {
  const TenantModel({
    super.tenantId,
    required super.fullName,
    super.phoneNumber,
    super.email,
    super.nationalId,
    super.notes,
    required super.createdAt,
  });

  factory TenantModel.fromMap(Map<String, dynamic> map) {
    return TenantModel(
      tenantId: map[DatabaseHelper.colTenantId] as int?,
      fullName: map[DatabaseHelper.colTenantFullName] as String,
      phoneNumber: map[DatabaseHelper.colTenantPhoneNumber] as String?,
      email: map[DatabaseHelper.colTenantEmail] as String?,
      nationalId: map[DatabaseHelper.colTenantNationalId] as String?,
      notes: map[DatabaseHelper.colTenantNotes] as String?,
      createdAt: DateTime.parse(
        map[DatabaseHelper.colTenantCreatedAt] as String,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (tenantId != null) DatabaseHelper.colTenantId: tenantId,
      DatabaseHelper.colTenantFullName: fullName,
      DatabaseHelper.colTenantPhoneNumber: phoneNumber,
      DatabaseHelper.colTenantNationalId: nationalId,
      DatabaseHelper.colTenantEmail: email,
      DatabaseHelper.colTenantNotes: notes,
      DatabaseHelper.colTenantCreatedAt: createdAt.toIso8601String(),
    };
  }

  TenantModel copyWith({
    int? tenantId,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? nationalId,
    String? notes,
    DateTime? createdAt,
  }) {
    return TenantModel(
      tenantId: tenantId ?? this.tenantId,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      nationalId: nationalId ?? this.nationalId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
