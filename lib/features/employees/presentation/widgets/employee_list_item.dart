import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:raja_c_flutter_employees/features/employees/domain/entities/employee.dart';
import 'package:raja_c_flutter_employees/core/utils/date_formatter.dart';

class EmployeeListItem extends StatelessWidget {
  final Employee employee;
  const EmployeeListItem({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      /* leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Text(
                employee.name.isNotEmpty ? employee.name[0].toUpperCase() : '?',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ), */
      title: Text(employee.name),
      subtitle: Text(
        DateFormatter.formatDateRange(employee.joinDate, employee.exitDate),
      ),
      //trailing: const Icon(Icons.chevron_right),
      onTap: () => context.go('/add-or-edit?id=${employee.id}'),
    );
  }
}
