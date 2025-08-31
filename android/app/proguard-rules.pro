# Proguard rules for Isar and Flutter
-keep class isar.** { *; }
-keep class dev.isar.** { *; }
-keep class com.example.raja_c_flutter_employees.** { *; }
# Flutter JNI
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.engine.FlutterJNI
