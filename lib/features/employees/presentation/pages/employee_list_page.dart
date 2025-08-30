import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:raja_c_flutter_employees/features/employees/presentation/bloc/employee_bloc.dart';
import 'package:raja_c_flutter_employees/features/employees/presentation/widgets/employee_list_item.dart';

import '../../domain/entities/employee.dart';
import '../widgets/empty_employee_list.dart';

class EmployeeListPage extends StatelessWidget {
  const EmployeeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // The BlocProvider is now in the router, so we can directly use the Scaffold
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
        /* actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<EmployeeBloc>().add(RefreshEmployees());
            },
          ),
        ], */
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add-or-edit'),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoaded && state.employees.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10,
              ),
              child: Text(
                'Swipe left to delete',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EmployeeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<EmployeeBloc>().add(LoadEmployees());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is EmployeeLoaded && state.employees.isEmpty) {
            return const EmptyEmployeeList();
          }

          if (state is EmployeeLoaded) {
            final now = DateTime.now();

            // Enhanced filtering with chronological validation
            final current = state.employees.where((e) {
              // Current employee criteria:
              // 1. No exit date (still employed)
              // 2. Valid join date (not in future)
              // 3. If exit date exists, it should be in future (data correction)
              // 4. If exit date is today and join date is today, not current
              if (e.exitDate == null) {
                return e.joinDate.isBefore(now.add(const Duration(days: 1)));
              }
              return false;
            }).toList();

            final previous = state.employees.where((e) {
              // Previous employee criteria:
              // 1. Has exit date (employment ended)
              // 2. Exit date is not in future
              // 3. Exit date is same as or after join date (chronological validation)
              // 4. Join date is valid (not in future)
              return e.exitDate != null &&
                  e.exitDate!.isBefore(now.add(const Duration(days: 1))) &&
                  !e.exitDate!.isBefore(e.joinDate) &&
                  e.joinDate.isBefore(now.add(const Duration(days: 1)));
            }).toList();

            // Sort current employees by join date (newest first)
            current.sort((a, b) => b.joinDate.compareTo(a.joinDate));

            // Sort previous employees by exit date (most recent departure first)
            previous.sort((a, b) => b.exitDate!.compareTo(a.exitDate!));

            // Data validation: Log any anomalies for debugging
            final anomalies = state.employees.where((e) {
              return (e.exitDate != null && e.exitDate!.isBefore(e.joinDate)) ||
                  e.joinDate.isAfter(now.add(const Duration(days: 1))) ||
                  (e.exitDate != null &&
                      e.exitDate!.isAfter(now.add(const Duration(days: 1))));
            }).toList();

            // If there are data anomalies, they could be shown in a separate section
            // or handled according to business rules
            if (anomalies.isNotEmpty && kDebugMode) {
              debugPrint(
                'Data anomalies detected: ${anomalies.length} employees',
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                // Wait for the refresh event to complete
                final bloc = context.read<EmployeeBloc>();
                final completer = Completer<void>();
                bloc.stream
                    .firstWhere((state) => state is! EmployeeRefreshing)
                    .then((_) {
                      if (!completer.isCompleted) completer.complete();
                    });
                bloc.add(RefreshEmployees());
                return completer.future;
              },
              child: CustomScrollView(
                slivers: [
                  if (current.isNotEmpty)
                    _StickyHeader(title: 'Current employees'),
                  _EmployeeSliverList(
                    employees: current,
                    onDismissed: (employee) =>
                        _deleteEmployee(context, employee),
                  ),
                  if (previous.isNotEmpty)
                    _StickyHeader(title: 'Previous employees'),
                  _EmployeeSliverList(
                    employees: previous,
                    onDismissed: (employee) =>
                        _deleteEmployee(context, employee),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _deleteEmployee(BuildContext context, Employee employee) {
    final bloc = context.read<EmployeeBloc>();
    bloc.add(DeleteEmployee(employee.id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Employee ${employee.name}\'s data has been deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Theme.of(context).colorScheme.primary,
          onPressed: () => bloc.add(AddEmployee(employee)),
        ),
      ),
    );
  }
}

class _StickyHeader extends StatelessWidget {
  final String title;
  const _StickyHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _HeaderDelegate(title),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  _HeaderDelegate(this.title);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 48;
  @override
  double get minExtent => 48;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class _EmployeeSliverList extends StatelessWidget {
  final List<Employee> employees;
  final Function(Employee) onDismissed;
  const _EmployeeSliverList({
    required this.employees,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index.isOdd) {
          return Divider(
            height: 0.5,
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
          );
        }

        final empIndex = index ~/ 2;
        final emp = employees[empIndex];
        return Dismissible(
          key: Key(emp.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.redAccent,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => onDismissed(emp),
          child: EmployeeListItem(employee: emp),
        );
      }, childCount: employees.length * 2 - 1),
    );
  }
}
