import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:raja_c_flutter_employees/features/employees/domain/entities/employee.dart';
import 'package:raja_c_flutter_employees/features/employees/domain/usecases/get_employees.dart';
import 'package:raja_c_flutter_employees/features/employees/domain/usecases/add_employee.dart'
    as usecases;
import 'package:raja_c_flutter_employees/features/employees/domain/usecases/delete_employee.dart'
    as usecases;

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final GetEmployees getEmployees;
  final usecases.AddEmployee addEmployee;
  final usecases.DeleteEmployee deleteEmployee;

  EmployeeBloc({
    required this.getEmployees,
    required this.addEmployee,
    required this.deleteEmployee,
  }) : super(EmployeeInitial()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<RefreshEmployees>(_onRefreshEmployees);
    on<DeleteEmployee>(_onDeleteEmployee);
    on<AddEmployee>(_onAddEmployee);
  }

  Future<void> _onLoadEmployees(
    LoadEmployees event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());

    final result = await getEmployees();

    result.fold(
      (failure) => emit(EmployeeError(message: failure.message)),
      (employees) => emit(EmployeeLoaded(employees: employees)),
    );
  }

  Future<void> _onRefreshEmployees(
    RefreshEmployees event,
    Emitter<EmployeeState> emit,
  ) async {
    final currentState = state;
    if (currentState is EmployeeLoaded) {
      emit(EmployeeRefreshing(employees: currentState.employees));

      final result = await getEmployees();

      result.fold(
        (failure) => emit(EmployeeError(message: failure.message)),
        (employees) => emit(EmployeeLoaded(employees: employees)),
      );
    }
  }

  Future<void> _onDeleteEmployee(
    DeleteEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    final currentState = state;

    // Optimistically update the UI if we have a loaded state
    if (currentState is EmployeeLoaded) {
      final updatedEmployees = List<Employee>.from(currentState.employees)
        ..removeWhere((e) => e.id == event.employeeId);
      emit(EmployeeLoaded(employees: updatedEmployees));
    }

    // Call the DeleteEmployee use case to delete the employee from the database
    final result = await deleteEmployee(event.employeeId);

    // Handle the result
    result.fold(
      (failure) {
        // If there was an error, show it
        if (!emit.isDone) {
          emit(EmployeeError(message: failure.message));
        }
      },
      (_) {
        // Success case - we'll reload employees below
      },
    );

    // Always reload employees to ensure UI is in sync with database
    if (!emit.isDone) {
      await _reloadEmployees(emit);
    }
  }

  Future<void> _onAddEmployee(
    AddEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    // Call the AddEmployee use case to persist the employee to the database
    final result = await addEmployee(event.employee);

    // Handle the result
    result.fold(
      (failure) {
        // If there was an error, show it
        if (!emit.isDone) {
          emit(EmployeeError(message: failure.message));
        }
      },
      (_) {
        // Success case - we'll reload employees below
      },
    );

    // Always reload employees to ensure UI is in sync with database
    if (!emit.isDone) {
      await _reloadEmployees(emit);
    }
  }

  Future<void> _reloadEmployees(Emitter<EmployeeState> emit) async {
    if (emit.isDone) return; // Don't emit if already completed

    final result = await getEmployees();

    if (emit.isDone) return; // Check again after async operation

    result.fold(
      (failure) => emit(EmployeeError(message: failure.message)),
      (employees) => emit(EmployeeLoaded(employees: employees)),
    );
  }
}
