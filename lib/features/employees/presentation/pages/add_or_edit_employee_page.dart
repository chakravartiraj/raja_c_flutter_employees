import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:raja_c_flutter_employees/features/employees/domain/entities/employee.dart';
import '../bloc/employee_bloc.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_role_selector.dart';
import '../widgets/custom_date_fields.dart';

class AddOrEditEmployeePage extends StatefulWidget {
  final String? employeeId;
  const AddOrEditEmployeePage({super.key, this.employeeId});

  @override
  State<AddOrEditEmployeePage> createState() => _AddOrEditEmployeePageState();
}

class _AddOrEditEmployeePageState extends State<AddOrEditEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  EmployeeRole? _selectedRole;
  DateTime? _joinDate;
  DateTime? _exitDate;
  bool _isOperationInProgress = false;

  @override
  void initState() {
    super.initState();
    final existing = _existingEmployee;
    _nameCtrl = TextEditingController(text: existing?.name ?? '');
    _selectedRole = existing?.role;
    _joinDate = existing?.joinDate;
    _exitDate = existing?.exitDate;
  }

  Employee? get _existingEmployee {
    if (widget.employeeId == null) return null;

    final state = context.read<EmployeeBloc>().state;
    if (state is EmployeeLoaded) {
      try {
        return state.employees.firstWhere((e) => e.id == widget.employeeId);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  bool get _isEdit => widget.employeeId != null;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeBloc, EmployeeState>(
      listener: (context, state) {
        if (state is EmployeeLoaded && _isOperationInProgress) {
          // Reset operation flag
          _isOperationInProgress = false;

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Operation completed successfully'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          // Navigate back on success
          _navigateBack();
        } else if (state is EmployeeError) {
          // Reset operation flag
          _isOperationInProgress = false;

          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            _navigateBack();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              _isEdit ? 'Edit Employee Details' : 'Add Employee Details',
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _navigateBack,
            ),
            actions: _isEdit
                ? [
                    IconButton(
                      icon: const Icon(Icons.delete_outlined),
                      tooltip: 'Delete',
                      onPressed: _handleDelete,
                    ),
                  ]
                : null,
          ), // AppBar closing
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Name
                CustomInputField(
                  hintText: 'Employee Name',
                  controller: _nameCtrl,
                  icon: Icons.person,
                  initialValue: _nameCtrl.text,
                  validator: (v) =>
                      (v?.trim().isEmpty ?? true) ? 'Required' : null,
                ),
                const SizedBox(height: 20),

                // Role
                CustomRoleSelector(
                  selectedRole: _selectedRole,
                  initialValue: _selectedRole,
                  onRoleSelected: (role) =>
                      setState(() => _selectedRole = role),
                  validator: (v) => v == null ? 'Required' : null,
                ),
                const SizedBox(height: 20),

                // Joining Date & Exit Date
                CustomDateFields(
                  joinDate: _joinDate,
                  exitDate: _exitDate,
                  onJoinDateChanged: (date) => setState(() => _joinDate = date),
                  onExitDateChanged: (date) => setState(() => _exitDate = date),
                  validator: (dates) {
                    // Handle null dates map
                    if (dates == null) {
                      return 'Required';
                    }

                    final joinDate = dates['joinDate'];
                    final exitDate = dates['exitDate'];

                    // Joining date is required
                    if (joinDate == null) {
                      return 'Required';
                    }

                    // Exit date must be after joining date if provided
                    if (exitDate != null && exitDate.isBefore(joinDate)) {
                      return 'Exit date must be after joining date';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.only(
              left: 5,
              right: 10,
              top: 10,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(flex: 2, child: SizedBox()),
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: _navigateBack,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: FilledButton(
                    onPressed: _handleSave,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                    ),
                    child: Text(_isEdit ? 'Update' : 'Save'),
                  ),
                ),
              ],
            ),
          ), // Scaffold closing
        ),
      ),
    ); // BlocListener and PopScope closing
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    final trimmedName = _nameCtrl.text.trim();
    final isEdit = _isEdit;
    final existing = _existingEmployee;

    if (isEdit && existing != null) {
      final unchanged =
          trimmedName == existing.name &&
          _selectedRole == existing.role &&
          _joinDate == existing.joinDate &&
          _exitDate == existing.exitDate;
      if (unchanged) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No changes to save.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
    }

    // Set operation flag
    _isOperationInProgress = true;

    final employee = Employee(
      id: existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: trimmedName,
      role: _selectedRole!,
      joinDate: _joinDate!,
      exitDate: _exitDate,
    );

    // Use AddEmployee event for both add and edit operations
    context.read<EmployeeBloc>().add(AddEmployee(employee));
    // Don't navigate back here - let BlocListener handle it
  }

  void _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete employee?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      // Set operation flag
      _isOperationInProgress = true;

      context.read<EmployeeBloc>().add(DeleteEmployee(widget.employeeId!));
      // Don't navigate back here - let BlocListener handle it
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  /// Helper method to safely navigate back or to home
  void _navigateBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }
}
