import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final String id;
  final String name;
  final EmployeeRole role;
  final DateTime joinDate;
  final DateTime? exitDate;

  const Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.joinDate,
    this.exitDate,
  });

  bool get isCurrent => exitDate == null || exitDate!.isAfter(DateTime.now());

  @override
  List<Object?> get props => [id, name, role, joinDate, exitDate];
}

enum EmployeeRole {
  productDesigner('Product Designer'),
  flutterDeveloper('Flutter Developer'),
  qaTester('QA Tester'),
  productOwner('Product Owner');

  const EmployeeRole(this.label);
  final String label;
}
