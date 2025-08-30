// lib/features/employees/data/datasources/employee_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:raja_c_flutter_employees/features/employees/data/models/employee_model.dart';
import 'package:raja_c_flutter_employees/features/employees/domain/entities/employee.dart';

abstract class EmployeeRemoteDataSource {
  Future<List<Employee>> getEmployees();
  Future<Employee> getEmployeeById(String id);
  Future<Employee> addEmployee(Employee employee);
  Future<Employee> updateEmployee(Employee employee);
  Future<void> deleteEmployee(String id);
}

class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  final Dio dio;

  EmployeeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<Employee>> getEmployees() async {
    try {
      final response = await dio.get('/employees');

      // Convert List<dynamic> to List<EmployeeModel> then to List<Employee>
      final List<dynamic> data = response.data;
      return data
          .map((json) => EmployeeModel.fromJson(json as Map<String, dynamic>))
          .map((model) => model.toEntity())
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch employees: ${e.message}');
    }
  }

  @override
  Future<Employee> getEmployeeById(String id) async {
    try {
      final response = await dio.get('/employees/$id');

      // Convert JSON to EmployeeModel then to Employee entity
      return EmployeeModel.fromJson(
        response.data as Map<String, dynamic>,
      ).toEntity();
    } on DioException catch (e) {
      throw Exception('Failed to fetch employee: ${e.message}');
    }
  }

  @override
  Future<Employee> addEmployee(Employee employee) async {
    try {
      // Convert Employee entity to EmployeeModel for JSON serialization
      final model = EmployeeModel.fromEntity(employee);

      final response = await dio.post('/employees', data: model.toJson());

      // Convert response JSON back to Employee entity
      return EmployeeModel.fromJson(
        response.data as Map<String, dynamic>,
      ).toEntity();
    } on DioException catch (e) {
      throw Exception('Failed to add employee: ${e.message}');
    }
  }

  @override
  Future<Employee> updateEmployee(Employee employee) async {
    try {
      // Convert Employee entity to EmployeeModel for JSON serialization
      final model = EmployeeModel.fromEntity(employee);

      final response = await dio.put(
        '/employees/${employee.id}',
        data: model.toJson(),
      );

      // Convert response JSON back to Employee entity
      return EmployeeModel.fromJson(
        response.data as Map<String, dynamic>,
      ).toEntity();
    } on DioException catch (e) {
      throw Exception('Failed to update employee: ${e.message}');
    }
  }

  @override
  Future<void> deleteEmployee(String id) async {
    try {
      await dio.delete('/employees/$id');
    } on DioException catch (e) {
      throw Exception('Failed to delete employee: ${e.message}');
    }
  }
}
