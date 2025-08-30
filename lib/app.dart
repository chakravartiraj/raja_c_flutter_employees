import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raja_c_flutter_employees/core/di/dependency_injection.dart';
import 'package:raja_c_flutter_employees/core/routing/app_router.dart';
import 'package:raja_c_flutter_employees/core/theme/app_theme.dart';
import 'package:raja_c_flutter_employees/features/employees/presentation/bloc/employee_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => locator<EmployeeBloc>()..add(LoadEmployees()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Employee Management',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
