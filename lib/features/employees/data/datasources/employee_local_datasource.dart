// lib/features/employees/data/datasources/employee_local_datasource.dart
import 'package:isar/isar.dart';
import 'package:raja_c_flutter_employees/features/employees/data/models/employee_model.dart';
import 'package:raja_c_flutter_employees/features/employees/domain/entities/employee.dart';

abstract class EmployeeLocalDataSource {
  Future<List<Employee>> getCachedEmployees();
  Future<Employee> getEmployeeById(String id);
  Future<void> cacheEmployees(List<Employee> employees);
  Future<void> cacheEmployee(Employee employee);
  Future<void> updateCachedEmployee(Employee employee);
  Future<void> removeCachedEmployee(String id);
  Future<void> clearCache();
}

class EmployeeLocalDataSourceImpl implements EmployeeLocalDataSource {
  final Isar isar;

  EmployeeLocalDataSourceImpl({required this.isar});

  @override
  Future<List<Employee>> getCachedEmployees() async {
    final models = await isar.employeeModels.where().findAll();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Employee> getEmployeeById(String id) async {
    final model = await isar.employeeModels.filter().idEqualTo(id).findFirst();
    if (model == null) {
      throw Exception('Employee not found');
    }
    return model.toEntity();
  }

  @override
  Future<void> cacheEmployees(List<Employee> employees) async {
    final models = employees.map((e) => EmployeeModel.fromEntity(e)).toList();

    await isar.writeTxn(() async {
      await isar.employeeModels.clear();
      await isar.employeeModels.putAll(models);
    });
  }

  @override
  Future<void> cacheEmployee(Employee employee) async {
    final model = EmployeeModel.fromEntity(employee);

    await isar.writeTxn(() async {
      await isar.employeeModels.put(model);
    });
  }

  @override
  Future<void> updateCachedEmployee(Employee employee) async {
    // Reuse cacheEmployee since it already handles updating
    await cacheEmployee(employee);
  }

  @override
  Future<void> removeCachedEmployee(String id) async {
    await isar.writeTxn(() async {
      await isar.employeeModels.filter().idEqualTo(id).deleteFirst();
    });
  }

  @override
  Future<void> clearCache() async {
    await isar.writeTxn(() async {
      await isar.employeeModels.clear();
    });
  }
}
