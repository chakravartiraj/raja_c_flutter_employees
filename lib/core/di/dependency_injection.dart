// lib/core/di/dependency_injection.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:raja_c_flutter_employees/features/employees/data/datasources/employee_local_datasource.dart';
import 'package:raja_c_flutter_employees/features/employees/data/datasources/employee_remote_datasource.dart';
import 'package:raja_c_flutter_employees/features/employees/data/models/employee_model.dart'; // Add this import
import 'package:raja_c_flutter_employees/features/employees/data/repositories/employee_repository_impl.dart';
import 'package:raja_c_flutter_employees/features/employees/domain/repositories/employee_repository.dart';
import 'package:raja_c_flutter_employees/features/employees/domain/usecases/get_employees.dart';
import 'package:raja_c_flutter_employees/features/employees/domain/usecases/add_employee.dart'
    as usecases;
import 'package:raja_c_flutter_employees/features/employees/domain/usecases/delete_employee.dart'
    as usecases;
import 'package:raja_c_flutter_employees/features/employees/presentation/bloc/employee_bloc.dart';
import 'package:raja_c_flutter_employees/core/network/network_info.dart';

import '../../features/employees/presentation/bloc/employee_bloc.dart'
    show EmployeeBloc;

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // Dio
  locator.registerLazySingleton<Dio>(() => Dio());

  // Network info
  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(Connectivity()),
  );

  // Isar
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([EmployeeModelSchema], directory: dir.path);
  locator.registerLazySingleton<Isar>(() => isar);

  // Data Sources
  locator.registerLazySingleton<EmployeeRemoteDataSource>(
    () => EmployeeRemoteDataSourceImpl(dio: locator()),
  );
  locator.registerLazySingleton<EmployeeLocalDataSource>(
    () => EmployeeLocalDataSourceImpl(isar: locator()),
  );

  // Repositories
  locator.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );

  // Use Cases
  locator.registerLazySingleton<GetEmployees>(
    () => GetEmployees(repository: locator()),
  );
  locator.registerLazySingleton<usecases.AddEmployee>(
    () => usecases.AddEmployee(repository: locator()),
  );
  locator.registerLazySingleton<usecases.DeleteEmployee>(
    () => usecases.DeleteEmployee(repository: locator()),
  );

  // Blocs
  locator.registerFactory<EmployeeBloc>(
    () => EmployeeBloc(
      getEmployees: locator(),
      addEmployee: locator(),
      deleteEmployee: locator(),
    ),
  );
}
