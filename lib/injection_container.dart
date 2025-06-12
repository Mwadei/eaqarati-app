import 'package:eaqarati_app/core/services/payment_schedule_service.dart';
import 'package:eaqarati_app/core/services/settings_service.dart';
import 'package:eaqarati_app/features/data/repositories/lease_repository_impl.dart';
import 'package:eaqarati_app/features/data/repositories/payment_repository_impl.dart';
import 'package:eaqarati_app/features/data/repositories/property_repository_impl.dart';
import 'package:eaqarati_app/features/data/repositories/scheduled_payment_repository_impl.dart';
import 'package:eaqarati_app/features/data/repositories/tenant_repository_impl.dart';
import 'package:eaqarati_app/features/data/repositories/units_repository_impl.dart';
import 'package:eaqarati_app/features/data/sources/local/database_helper.dart';
import 'package:eaqarati_app/features/data/sources/local/lease_local_data_source.dart';
import 'package:eaqarati_app/features/data/sources/local/payment_local_data_source.dart';
import 'package:eaqarati_app/features/data/sources/local/property_local_data_source.dart';
import 'package:eaqarati_app/features/data/sources/local/scheduled_payment_local_data_source.dart';
import 'package:eaqarati_app/features/data/sources/local/tenant_local_data_source.dart';
import 'package:eaqarati_app/features/data/sources/local/unit_local_data_source.dart';
import 'package:eaqarati_app/features/domain/repositories/lease_repository.dart';
import 'package:eaqarati_app/features/domain/repositories/payment_repository.dart';
import 'package:eaqarati_app/features/domain/repositories/property_repository.dart';
import 'package:eaqarati_app/features/domain/repositories/scheduled_payment_repository.dart';
import 'package:eaqarati_app/features/domain/repositories/tenant_repository.dart';
import 'package:eaqarati_app/features/domain/repositories/units_repository.dart';
import 'package:eaqarati_app/features/domain/usecases/leases/add_lease_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/leases/delete_lease_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/leases/get_active_leases_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/leases/get_all_leases_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/leases/get_lease_by_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/leases/get_leases_by_tenant_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/leases/get_leases_by_unit_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/leases/update_lease_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/orchestration/create_lease_with_schedule_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/orchestration/generate_annual_financial_statement_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/orchestration/update_lease_with_schedule_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/payments/delete_payment_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/payments/get_all_payments_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/payments/get_payment_by_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/payments/get_payments_by_lease_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/payments/get_payments_by_scheduled_payment_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/payments/get_payments_by_tenant_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/payments/record_payment_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/property/add_property_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/property/delete_property_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/property/get_all_properties_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/property/get_property_by_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/property/update_property_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/scheduled_payment/add_scheduled_payment_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/scheduled_payment/add_scheduled_payments_batch_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/scheduled_payment/delete_scheduled_payment_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/scheduled_payment/delete_scheduled_payments_by_lease_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/scheduled_payment/get_all_scheduled_payment_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/scheduled_payment/get_overdue_scheduled_payments_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/scheduled_payment/get_scheduled_payment_by_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/scheduled_payment/get_scheduled_payment_by_status.dart';
import 'package:eaqarati_app/features/domain/usecases/scheduled_payment/get_scheduled_payments_by_lease_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/scheduled_payment/get_upcoming_scheduled_payments_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/scheduled_payment/update_scheduled_payment_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/tenants/add_tenant_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/tenants/delete_tenant_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/tenants/get_all_tenants_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/tenants/get_tenant_by_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/tenants/update_tenant_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/units/add_unit_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/units/delete_unit_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/units/get_all_units_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/units/get_unit_by_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/units/get_units_by_property_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/units/update_unit_use_case.dart';
import 'package:eaqarati_app/features/presentation/blocs/lease/lease_bloc.dart';
import 'package:eaqarati_app/features/presentation/blocs/payment/payment_bloc.dart';
import 'package:eaqarati_app/features/presentation/blocs/property/property_bloc.dart';
import 'package:eaqarati_app/features/presentation/blocs/scheduled_payment/scheduled_payment_bloc.dart';
import 'package:eaqarati_app/features/presentation/blocs/settings/settings_bloc.dart';
import 'package:eaqarati_app/features/presentation/blocs/tenant/tenant_bloc.dart';
import 'package:eaqarati_app/features/presentation/blocs/units/units_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ----- Properties -----
  // Use Cases
  sl.registerLazySingleton(() => AddPropertyUseCase(sl()));
  sl.registerLazySingleton(() => GetAllPropertiesUseCase(sl()));
  sl.registerLazySingleton(() => GetPropertyByIdUseCase(sl()));
  sl.registerLazySingleton(() => DeletePropertyUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePropertyUseCase(sl()));
  // Repositories
  sl.registerLazySingleton<PropertyRepository>(
    () => PropertyRepositoryImpl(localDataSource: sl()),
  );
  // Data Sources
  sl.registerLazySingleton<PropertyLocalDataSource>(
    () => PropertyLocalDataSourceImpl(databaseHelper: sl()),
  );

  // ----- Units -----
  // Use Cases
  sl.registerLazySingleton(() => AddUnitUseCase(unitsRepository: sl()));
  sl.registerLazySingleton(() => UpdateUnitUseCase(unitsRepository: sl()));
  sl.registerLazySingleton(() => DeleteUnitUseCase(unitsRepository: sl()));
  sl.registerLazySingleton(() => GetAllUnitsUseCase(unitsRepository: sl()));
  sl.registerLazySingleton(() => GetUnitByIdUseCase(unitsRepository: sl()));
  sl.registerLazySingleton(
    () => GetUnitsByPropertyIdUseCase(unitsRepository: sl()),
  );

  // Repositories
  sl.registerLazySingleton<UnitsRepository>(
    () => UnitsRepositoryImpl(unitLocalDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<UnitLocalDataSource>(
    () => UnitLocalDataSourceImpl(databaseHelper: sl()),
  );

  // ----- Tenants  -----
  // Use Cases
  sl.registerLazySingleton(() => AddTenantUseCase(sl()));
  sl.registerLazySingleton(() => GetAllTenantsUseCase(sl()));
  sl.registerLazySingleton(() => GetTenantByIdUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTenantUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTenantUseCase(sl()));
  // Repository
  sl.registerLazySingleton<TenantRepository>(
    () => TenantRepositoryImpl(tenantLocalDataSource: sl()),
  );
  // Data Source
  sl.registerLazySingleton<TenantLocalDataSource>(
    () => TenantLocalDataSourceImpl(databaseHelper: sl()),
  );

  // ----- Leases -----
  // Use Cases
  sl.registerLazySingleton(() => AddLeaseUseCase(sl()));
  sl.registerLazySingleton(() => GetLeaseByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetAllLeasesUseCase(sl()));
  sl.registerLazySingleton(() => GetLeasesByUnitIdUseCase(sl()));
  sl.registerLazySingleton(() => GetLeasesByTenantIdUseCase(sl()));
  sl.registerLazySingleton(() => GetActiveLeasesUseCase(sl()));
  sl.registerLazySingleton(() => UpdateLeaseUseCase(sl()));
  sl.registerLazySingleton(() => DeleteLeaseUseCase(sl()));
  // Repository
  sl.registerLazySingleton<LeaseRepository>(
    () => LeaseRepositoryImpl(localDataSource: sl()),
  );
  // Data Source
  sl.registerLazySingleton<LeaseLocalDataSource>(
    () => LeaseLocalDataSourceImpl(databaseHelper: sl()),
  );

  // ----- ScheduledPayments -----
  // Use Cases
  sl.registerLazySingleton(() => AddScheduledPaymentUseCase(sl()));
  sl.registerLazySingleton(() => AddScheduledPaymentsBatchUseCase(sl()));
  sl.registerLazySingleton(() => GetScheduledPaymentByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetScheduledPaymentsByLeaseIdUseCase(sl()));
  sl.registerLazySingleton(() => GetOverdueScheduledPaymentsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateScheduledPaymentUseCase(sl()));
  sl.registerLazySingleton(() => DeleteScheduledPaymentUseCase(sl()));
  sl.registerLazySingleton(() => DeleteScheduledPaymentsByLeaseIdUseCase(sl()));
  sl.registerLazySingleton(() => GetAllScheduledPaymentUseCase(sl()));
  sl.registerLazySingleton(() => GetScheduledPaymentByStatus(sl()));
  sl.registerLazySingleton(() => GetUpcomingScheduledPaymentsUseCase(sl()));
  // Repository
  sl.registerLazySingleton<ScheduledPaymentRepository>(
    () => ScheduledPaymentRepositoryImpl(localDataSource: sl()),
  );
  // Data Source
  sl.registerLazySingleton<ScheduledPaymentLocalDataSource>(
    () => ScheduledPaymentLocalDataSourceImpl(databaseHelper: sl()),
  );

  // ----- Payments -----
  // Use Cases
  sl.registerLazySingleton(
    () => RecordPaymentUseCase(
      paymentRepository: sl(),
      scheduledPaymentRepository: sl(),
      databaseHelper: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetPaymentByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetAllPaymentsUseCase(sl()));
  sl.registerLazySingleton(() => GetPaymentsByLeaseIdUseCase(sl()));
  sl.registerLazySingleton(() => GetPaymentsByTenantIdUseCase(sl()));
  sl.registerLazySingleton(() => GetPaymentsByScheduledPaymentIdUseCase(sl()));
  sl.registerLazySingleton(
    () => DeletePaymentUseCase(
      paymentRepository: sl(),
      scheduledPaymentRepository: sl(),
      databaseHelper: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(localDataSource: sl()),
  );
  // Data Source
  sl.registerLazySingleton<PaymentLocalDataSource>(
    () => PaymentLocalDataSourceImpl(databaseHelper: sl()),
  );

  // ----- Orchestration -----
  // Use Cases
  sl.registerLazySingleton(
    () => GenerateAnnualFinancialStatementUseCase(
      propertyRepository: sl(),
      unitsRepository: sl(),
      leaseRepository: sl(),
      tenantRepository: sl(),
      scheduledPaymentRepository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => CreateLeaseWithScheduleUseCase(
      addLeaseUseCase: sl(),
      paymentScheduleService: sl(),
      addScheduledPaymentsBatchUseCase: sl(),
      databaseHelper: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdateLeaseWithScheduleUseCase(
      updateLeaseUseCase: sl(),
      deleteScheduledPaymentsByLeaseIdUseCase: sl(),
      paymentScheduleService: sl(),
      addScheduledPaymentsBatchUseCase: sl(),
      databaseHelper: sl(),
    ),
  );

  //-------------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------------

  // ----- Services -----
  sl.registerLazySingleton(() => PaymentScheduleService());
  sl.registerLazySingleton(() => SettingsService());

  // ----- Database Helper -----
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

  // ----- Blocs -----
  sl.registerFactory(() => SettingsBloc(sl()));
  sl.registerFactory(
    () => LeaseBloc(
      getActiveLeasesUseCase: sl(),
      getAllLeasesUseCase: sl(),
      getLeaseByIdUseCase: sl(),
      getLeasesByTenantIdUseCase: sl(),
      getLeasesByUnitIdUseCase: sl(),
      deleteLeaseUseCase: sl(),
      createLeaseWithScheduleUseCase: sl(),
      updateLeaseWithScheduleUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => PaymentBloc(
      recordPaymentUseCase: sl(),
      getPaymentsByLeaseIdUseCase: sl(),
      getPaymentsByTenantIdUseCase: sl(),
      getPaymentsByScheduledPaymentIdUseCase: sl(),
      getPaymentByIdUseCase: sl(),
      deletePaymentUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => PropertyBloc(
      addPropertyUseCase: sl(),
      getAllPropertiesUseCase: sl(),
      getPropertyByIdUseCase: sl(),
      updatePropertyUseCase: sl(),
      deletePropertyUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ScheduledPaymentBloc(
      getScheduledPaymentsByLeaseIdUseCase: sl(),
      getScheduledPaymentByIdUseCase: sl(),
      getOverdueScheduledPaymentsUseCase: sl(),
      getScheduledPaymentByStatusUseCase: sl(),
      updateScheduledPaymentUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => TenantBloc(
      addTenantUseCase: sl(),
      getAllTenantsUseCase: sl(),
      getTenantByIdUseCase: sl(),
      updateTenantUseCase: sl(),
      deleteTenantUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => UnitsBloc(
      addUnitUseCase: sl(),
      getAllUnitsUseCase: sl(),
      getUnitsByPropertyIdUseCase: sl(),
      getUnitByIdUseCase: sl(),
      updateUnitUseCase: sl(),
      deleteUnitUseCase: sl(),
    ),
  );
}
