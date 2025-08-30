import 'package:dartz/dartz.dart';
import 'package:raja_c_flutter_employees/core/error/failures.dart';
import 'package:raja_c_flutter_employees/features/employees/domain/entities/employee.dart';
import 'package:raja_c_flutter_employees/features/employees/domain/repositories/employee_repository.dart';

class AddEmployee {
  final EmployeeRepository repository;

  AddEmployee({required this.repository});

  Future<Either<Failure, void>> call(Employee employee) async {
    return await repository.addEmployee(employee);
  }
}
