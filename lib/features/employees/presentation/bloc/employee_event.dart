part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class LoadEmployees extends EmployeeEvent {}

class RefreshEmployees extends EmployeeEvent {}

// employee_event.dart
class DeleteEmployee extends EmployeeEvent {
  final String employeeId;
  const DeleteEmployee(this.employeeId);
}

class AddEmployee extends EmployeeEvent {
  final Employee employee;
  const AddEmployee(this.employee);
}
