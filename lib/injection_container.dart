import 'package:eaqarati_app/features/data/repositories/property_repository_impl.dart';
import 'package:eaqarati_app/features/data/sources/local/database_helper.dart';
import 'package:eaqarati_app/features/data/sources/local/property/property_local_data_source.dart';
import 'package:eaqarati_app/features/domain/repositories/property_repository.dart';
import 'package:eaqarati_app/features/domain/usecases/property/add_property_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/property/delete_property_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/property/get_all_properties_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/property/get_property_by_id_use_case.dart';
import 'package:eaqarati_app/features/domain/usecases/property/update_property_use_case.dart';
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

  // Database Helper
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);
}
