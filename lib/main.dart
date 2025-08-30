import 'package:flutter/material.dart';
import 'package:raja_c_flutter_employees/app.dart';
import 'package:raja_c_flutter_employees/core/di/dependency_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await setupLocator();
  runApp(const MyApp());
}
