import 'package:go_router/go_router.dart';
import 'package:raja_c_flutter_employees/features/employees/presentation/pages/add_or_edit_employee_page.dart';
import 'package:raja_c_flutter_employees/features/employees/presentation/pages/employee_list_page.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const EmployeeListPage()),
      GoRoute(
        path: '/add-or-edit',
        builder: (context, state) {
          final id = state.uri.queryParameters['id'];
          return AddOrEditEmployeePage(employeeId: id);
        },
      ),
    ],
  );
}
