// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  /* ----------------------------------------------------------
   * 🔆 LIGHT THEME
   * ---------------------------------------------------------- */
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1DA1F2),
      brightness: Brightness.light,
      primary: const Color(0xFF1DA1F2),
      onPrimary: Colors.white,
      secondary: const Color(0xFFEDF8FF),
      onSecondary: const Color(0xFF1DA1F2),
      surface: Colors.white,
      onSurface: const Color(0xFF1A1A1A),
      surfaceContainerHighest: const Color(0xFFF5F6FA),
      onSurfaceVariant: const Color(0xFF6E7191),
      error: const Color(0xFFFF3B30),
      onError: Colors.white,
    ),

    /* Typography */
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: Color(0xFF1A1A1A),
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: Color(0xFF1A1A1A),
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: Color(0xFF1A1A1A),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: Color(0xFF4A4A68),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: Color(0xFF6E7191),
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: Colors.white,
      ),
    ),

    /* AppBar */
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1DA1F2),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),

    /* Icon Theme */
    iconTheme: const IconThemeData(color: Color(0xFF1DA1F2)),

    /* Cards */
    cardTheme: CardThemeData(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
    ),

    /* FAB */
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: const Color(0xFF1DA1F2),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
    ),

    /* Divider */
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE5E5EC),
      thickness: 1,
      space: 0,
    ),
  );

  /* ----------------------------------------------------------
   * 🌙 DARK THEME
   * ---------------------------------------------------------- */
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1DA1F2),
      brightness: Brightness.dark,
      primary: const Color(0xFF1DA1F2),
      onPrimary: Colors.white,
      secondary: const Color(0xFFEDF8FF),
      onSecondary: const Color(0xFF1DA1F2),
      surface: const Color(0xFF1C1C1E),
      onSurface: Colors.white,
      surfaceContainerHighest: const Color(0xFF2C2C2E),
      onSurfaceVariant: const Color(0xFFAEAEB2),
      error: const Color(0xFFFF453A),
      onError: Colors.white,
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: Color(0xFFAEAEB2),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: Color(0xFF8E8E93),
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: Colors.black,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1DA1F2),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),

    /* Icon Theme */
    iconTheme: const IconThemeData(color: Color(0xFF1DA1F2)),
    cardTheme: CardThemeData(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF2C2C2E),
      clipBehavior: Clip.antiAlias,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: const Color(0xFF1DA1F2),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF38383A),
      thickness: 1,
      space: 0,
    ),
  );
}
