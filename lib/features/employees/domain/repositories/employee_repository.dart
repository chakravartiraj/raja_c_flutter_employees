import 'package:dartz/dartz.dart';
import 'package:raja_c_flutter_employees/core/error/failures.dart';
import 'package:raja_c_flutter_employees/features/employees/domain/entities/employee.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, List<Employee>>> getEmployees();
  Future<Either<Failure, Employee>> getEmployeeById(String id);
  Future<Either<Failure, void>> addEmployee(Employee employee);
  Future<Either<Failure, void>> updateEmployee(Employee employee);
  Future<Either<Failure, void>> deleteEmployee(String id);
}
