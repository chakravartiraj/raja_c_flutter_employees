import 'package:dartz/dartz.dart';
import 'package:raja_c_flutter_employees/core/error/failures.dart';
import 'package:raja_c_flutter_employees/features/employees/domain/entities/employee.dart';
import 'package:raja_c_flutter_employees/features/employees/domain/repositories/employee_repository.dart';

class GetEmployees {
  final EmployeeRepository repository;

  GetEmployees({required this.repository});

  Future<Either<Failure, List<Employee>>> call() async {
    return await repository.getEmployees();
  }
}
