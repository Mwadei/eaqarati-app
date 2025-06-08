import 'package:eaqarati_app/features/data/repositories/property_repository_impl.dart';
import 'package:eaqarati_app/features/data/repositories/tenant_repository_impl.dart';
import 'package:eaqarati_app/features/data/repositories/units_repository_impl.dart';
import 'package:eaqarati_app/features/data/sources/local/database_helper.dart';
import 'package:eaqarati_app/features/data/sources/local/property_local_data_source.dart';
import 'package:eaqarati_app/features/data/sources/local/tenant_local_data_source.dart';
import 'package:eaqarati_app/features/data/sources/local/unit_local_data_source.dart';
import 'package:eaqarati_app/features/domain/repositories/property_repository.dart';
import 'package:eaqarati_app/features/domain/repositories/tenant_repository.dart';
import 'package:eaqarati_app/features/domain/repositories/units_repository.dart';
import 'package:eaqarati_app/features/domain/usecases/property/add_property_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/property/delete_property_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/property/get_all_properties_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/property/get_property_by_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/property/update_property_use_case.dart';
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

  // ----- Tenants (New) -----
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

  //-------------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------------

  // Database Helper
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);
}
