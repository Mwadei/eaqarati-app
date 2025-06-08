import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/data/models/tenant_model.dart';
import 'package:eaqarati_app/features/data/sources/local/tenant_local_data_source.dart';
import 'package:eaqarati_app/features/domain/entities/tenant_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/tenant_repository.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class TenantRepositoryImpl implements TenantRepository {
  final TenantLocalDataSource tenantLocalDataSource;
  final Logger _logger = Logger();

  TenantRepositoryImpl({required this.tenantLocalDataSource});

  @override
  Future<Either<Failure, int>> addTenant(TenantEntity tenant) async {
    try {
      final tenantModel = TenantModel(
        tenantId: tenant.tenantId,
        fullName: tenant.fullName,
        phoneNumber: tenant.phoneNumber,
        nationalId: tenant.nationalId,
        email: tenant.email,
        notes: tenant.notes,
        createdAt: tenant.createdAt,
      );

      if (tenantModel.tenantId != null) {
        _logger.w('Tenant ID must be null to add a new tenant.');
        return Left(
          DatabaseFailure(
            'Tenant ID must be null to add a new tenant via TenantRepositoryImpl. ',
          ),
        );
      }

      final id = await tenantLocalDataSource.addTenant(tenantModel);
      return Right(id);
    } on DatabaseException catch (e) {
      _logger.e(
        'DatabaseException while adding tenant: ${e.toString()} via TenantRepositoryImpl',
      );
      return Left(
        DatabaseFailure(
          'Failed to add tenant: ${e.toString()} via TenantRepositoryImpl',
        ),
      );
    } catch (e) {
      _logger.e(
        'Unexpected error while adding tenant: ${e.toString()} via TenantRepositoryImpl',
      );
      return Left(
        DatabaseFailure(
          'An unexpected error occurred: ${e.toString()} via TenantRepositoryImpl',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTenant(int tenantId) async {
    try {
      final count = await tenantLocalDataSource.deleteTenant(tenantId);
      if (count > 0) {
        return Right(unit);
      } else {
        _logger.w(
          'Tenant with ID $tenantId not found for deletion via TenantRepositoryImpl.',
        );
        return Left(
          NotFoundFailure(
            'Tenant with ID $tenantId not found for deletion via TenantRepositoryImpl.',
          ),
        );
      }
    } on DatabaseException catch (e) {
      _logger.e(
        'DatabaseException while deleting tenant: ${e.toString()} via TenantRepositoryImpl',
      );
      return Left(
        DatabaseFailure(
          'Failed to delete tenant: ${e.toString()} via TenantRepositoryImpl',
        ),
      );
    } catch (e) {
      _logger.e(
        'Unexpected error while deleting tenant: ${e.toString()} via TenantRepositoryImpl',
      );
      return Left(
        DatabaseFailure(
          'An unexpected error occurred: ${e.toString()} via TenantRepositoryImpl',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<TenantEntity>>> getAllTenants() async {
    try {
      final tenantModels = await tenantLocalDataSource.getAllTenants();
      return Right(tenantModels.map((model) => model as TenantEntity).toList());
    } on DatabaseException catch (e) {
      _logger.e(
        'DatabaseException while getting all tenants: ${e.toString()} via TenantRepositoryImpl',
      );
      return Left(
        DatabaseFailure(
          'Failed to get all tenants: ${e.toString()} via TenantRepositoryImpl',
        ),
      );
    } catch (e) {
      _logger.e(
        'Unexpected error while getting all tenants: ${e.toString()} via TenantRepositoryImpl',
      );
      return Left(
        DatabaseFailure(
          'An unexpected error occurred: ${e.toString()} via TenantRepositoryImpl',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, TenantEntity>> getTenantById(int tenantId) async {
    try {
      final tenantModel = await tenantLocalDataSource.getTenantById(tenantId);
      return Right(tenantModel as TenantEntity);
    } on DatabaseException catch (e) {
      _logger.e(
        'DatabaseException while getting tenant by ID $tenantId: ${e.toString()} via TenantRepositoryImpl',
      );
      return Left(
        DatabaseFailure(
          'Failed to get tenant by ID: ${e.toString()} via TenantRepositoryImpl',
        ),
      );
    } catch (e) {
      if (e.toString().contains('not found')) {
        _logger.w(
          'Tenant with ID $tenantId not found  via TenantRepositoryImpl.',
        );
        return Left(
          NotFoundFailure(
            'Tenant with ID $tenantId not found via TenantRepositoryImpl.',
          ),
        );
      }
      _logger.e(
        'Unexpected error while getting tenant by ID $tenantId: ${e.toString()} via TenantRepositoryImpl',
      );
      return Left(
        DatabaseFailure(
          'An unexpected error occurred: ${e.toString()} via TenantRepositoryImpl',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTenant(TenantEntity tenant) async {
    try {
      final tenantModel = TenantModel(
        tenantId: tenant.tenantId,
        fullName: tenant.fullName,
        phoneNumber: tenant.phoneNumber,
        email: tenant.email,
        nationalId: tenant.nationalId,
        notes: tenant.notes,
        createdAt: tenant.createdAt,
      );
      await tenantLocalDataSource.updateTenant(tenantModel);
      return Right(unit);
    } on DatabaseException catch (e) {
      _logger.e(
        'DatabaseException while updating tenant: ${e.toString()} via TenantRepositoryImpl',
      );
      return Left(
        DatabaseFailure(
          'Failed to update tenant: ${e.toString()} via TenantRepositoryImpl',
        ),
      );
    } catch (e) {
      _logger.e(
        'Unexpected error while updating tenant: ${e.toString()} via TenantRepositoryImpl',
      );
      return Left(
        DatabaseFailure(
          'An unexpected error occurred: ${e.toString()} via TenantRepositoryImpl',
        ),
      );
    }
  }
}
