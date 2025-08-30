import 'package:dartz/dartz.dart';
import 'package:raja_c_flutter_employees/core/error/failures.dart';
import 'package:raja_c_flutter_employees/features/employees/domain/repositories/employee_repository.dart';

class DeleteEmployee {
  final EmployeeRepository repository;

  DeleteEmployee({required this.repository});

  Future<Either<Failure, void>> call(String employeeId) async {
    return await repository.deleteEmployee(employeeId);
  }
}
