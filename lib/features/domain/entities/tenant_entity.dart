import 'package:equatable/equatable.dart';

class TenantEntity extends Equatable {
  final int? tenantId;
  final String fullName;
  final String? phoneNumber;
  final String? email;
  final String? nationalId;
  final String? notes;
  final DateTime createdAt;

  const TenantEntity({
    this.tenantId,
    required this.fullName,
    this.phoneNumber,
    this.email,
    this.nationalId,
    this.notes,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    tenantId,
    fullName,
    phoneNumber,
    email,
    nationalId,
    notes,
    createdAt,
  ];
}
