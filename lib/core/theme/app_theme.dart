import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryNile = Color(0xFF1A535C);
  static const Color secondaryDesert = Color(0xFFF7D488);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color accentPapyrus = Color(0xFFF4E9D8);
  static const Color backgroundSand = Color(0xFFF9F7F4);

  static const Color line1 = Color(0xFFE30613);
  static const Color line1Dark = Color(0xFFB0000A);
  static const Color line2 = Color(0xFFFFD700);
  static const Color line2Dark = Color(0xFFC9A600);
  static const Color line3 = Color(0xFF4CAF50);
  static const Color line3Dark = Color(0xFF2E7D32);
  static const Color line4 = Color(0xFF2196F3);
  static const Color lrt = Color(0xFF9C27B0);
  static const Color monorail = Color(0xFFFF9800);

  static const Color success = Color(0xFF00A86B);
  static const Color warning = Color(0xFFFFB800);
  static const Color error = Color(0xFFE6503F);
  static const Color info = Color(0xFF379AE6);

  static ThemeData lightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryNile,
      brightness: Brightness.light,
      primary: primaryNile,
      secondary: secondaryDesert,
      tertiary: accentGold,
      surface: Colors.white,
      error: error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundSand,
      fontFamily: 'Tajawal',
      textTheme: _buildTextTheme(),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 4,
        backgroundColor: primaryNile,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryNile, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        shape: CircleBorder(),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade200,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    );
  }

  static Color lineColor(String lineId, {double opacity = 1.0}) {
    switch (lineId.toLowerCase()) {
      case '1':
        return line1.withOpacity(opacity);
      case '2':
        return line2.withOpacity(opacity);
      case '3':
      case '3a':
      case '3b':
        return line3.withOpacity(opacity);
      case '4':
        return line4.withOpacity(opacity);
      case 'lrt':
        return lrt.withOpacity(opacity);
      default:
        return primaryNile.withOpacity(opacity);
    }
  }
}
