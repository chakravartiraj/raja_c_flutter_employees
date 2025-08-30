import 'package:dartz/dartz.dart';
import 'package:raja_c_flutter_employees/core/error/failures.dart';
import 'package:raja_c_flutter_employees/core/network/network_info.dart';
import 'package:raja_c_flutter_employees/features/employees/data/datasources/employee_local_datasource.dart';
import 'package:raja_c_flutter_employees/features/employees/data/datasources/employee_remote_datasource.dart';
import 'package:raja_c_flutter_employees/features/employees/domain/entities/employee.dart';
import 'package:raja_c_flutter_employees/features/employees/domain/repositories/employee_repository.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDataSource remoteDataSource;
  final EmployeeLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  EmployeeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Employee>>> getEmployees() async {
    try {
      if (await networkInfo.isConnected) {
        try {
          final employees = await remoteDataSource.getEmployees();
          await localDataSource.cacheEmployees(employees);
          return Right(employees);
        } catch (e) {
          // If remote fails, try to get cached employees
          try {
            final employees = await localDataSource.getCachedEmployees();
            return Right(employees);
          } catch (cacheError) {
            return Left(ServerFailure('Failed to fetch employees: $e'));
          }
        }
      } else {
        // No internet, get cached employees
        final employees = await localDataSource.getCachedEmployees();
        return Right(employees);
      }
    } catch (e) {
      // Return empty list instead of error when no employees are cached
      return const Right([]);
    }
  }

  @override
  Future<Either<Failure, Employee>> getEmployeeById(String id) async {
    try {
      if (await networkInfo.isConnected) {
        final employee = await remoteDataSource.getEmployeeById(id);
        return Right(employee);
      } else {
        final employee = await localDataSource.getEmployeeById(id);
        return Right(employee);
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addEmployee(Employee employee) async {
    try {
      // Always save locally first
      await localDataSource.cacheEmployee(employee);

      // Try to sync with remote if connected
      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.addEmployee(employee);
        } catch (e) {
          // If remote fails, employee is still saved locally
          // Log the error but don't fail the operation
          // TODO: Replace with proper logging framework
          // print('Failed to sync employee to remote: $e');
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateEmployee(Employee employee) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.updateEmployee(employee);
        await localDataSource.updateCachedEmployee(employee);
        return const Right(null);
      } else {
        return Left(ServerFailure('No internet connection'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEmployee(String id) async {
    try {
      // Always delete locally first
      await localDataSource.removeCachedEmployee(id);

      // Try to sync with remote if connected
      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.deleteEmployee(id);
        } catch (e) {
          // If remote fails, employee is still deleted locally
          // Log the error but don't fail the operation
          // TODO: Replace with proper logging framework
          // print('Failed to sync employee deletion to remote: $e');
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
