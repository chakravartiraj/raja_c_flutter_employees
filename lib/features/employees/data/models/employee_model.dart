import 'package:isar/isar.dart';
import 'package:raja_c_flutter_employees/features/employees/domain/entities/employee.dart';

part 'employee_model.g.dart';

@collection
class EmployeeModel {
  Id get isarId => fastHash(id);

  late String id;
  late String name;
  late EmployeeRole role;
  late DateTime joinDate;
  DateTime? exitDate;

  EmployeeModel();

  // ⇄ Converters
  factory EmployeeModel.fromEntity(Employee e) => EmployeeModel()
    ..id = e.id
    ..name = e.name
    ..role = e.role
    ..joinDate = e.joinDate
    ..exitDate = e.exitDate;

  Employee toEntity() => Employee(
    id: id,
    name: name,
    role: role,
    joinDate: joinDate,
    exitDate: exitDate,
  );

  // JSON
  factory EmployeeModel.fromJson(Map<String, dynamic> j) => EmployeeModel()
    ..id = j['id'] as String
    ..name = j['name'] as String
    ..role = EmployeeRole.values.byName(j['role'] as String)
    ..joinDate = DateTime.parse(j['joinDate'] as String)
    ..exitDate = j['exitDate'] == null
        ? null
        : DateTime.parse(j['exitDate'] as String);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'role': role.name,
    'joinDate': joinDate.toIso8601String(),
    'exitDate': exitDate?.toIso8601String(),
  };
}

int fastHash(String s) => s.hashCode;
