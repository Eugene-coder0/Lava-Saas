import 'package:flutter/material.dart';

class LavaTheme {
  // Brand Colors
  static const Color orangeStart = Color(0xFFFF6B00);
  static const Color orangeEnd = Color(0xFFFF9800);

  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color creamBackground = Color(0xFFFFF7ED);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [orangeStart, orangeEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier(ThemeMode.light);

  static bool get isDarkMode => themeMode.value == ThemeMode.dark;

  static void toggleTheme() {
    themeMode.value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFFAF7F2),
      primaryColor: orangeStart,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF2C2D30),
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: orangeStart,
        brightness: Brightness.light,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF111827),
      primaryColor: orangeStart,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1F2937),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1F2937),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: orangeStart,
        brightness: Brightness.dark,
      ),
    );
  }
}
