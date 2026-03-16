import 'package:flutter/material.dart';

class AppTheme {
  // ── Brand colors ──────────────────────────────────────────────────────────
  static const Color primaryNile = Color(0xFF1A535C);
  static const Color secondaryDesert = Color(0xFFF7D488);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color accentPapyrus = Color(0xFFF4E9D8);
  static const Color backgroundSand = Color(0xFFF9F7F4);

  // ── Metro line colors ─────────────────────────────────────────────────────
  static const Color line1 = Color(0xFF105195);
  static const Color line1Dark = Color(0xFF0A3A6B);
  static const Color line2 = Color(0xFFC8313A);
  static const Color line2Dark = Color(0xFF9A2028);
  static const Color line3 = Color(0xFF09A68E);
  static const Color line3Dark = Color(0xFF067A68);
  static const Color line4 = Color(0xFF2196F3);
  static const Color lrt = Color(0xFFA21D32);
  static const Color lrtDark = Color(0xFF781525);
  static const Color monorail = Color(0xFFFF9800);

  // ── Semantic colors ───────────────────────────────────────────────────────
  static const Color success = Color(0xFF00A86B);
  static const Color warning = Color(0xFFFFB800);
  static const Color error = Color(0xFFE6503F);
  static const Color info = Color(0xFF379AE6);

  // ── Dark mode palette ─────────────────────────────────────────────────────
  // Evokes a nighttime Cairo skyline: deep midnight navy, gold accents, cyan Nile.
  static const Color darkBackground = Color(0xFF0B1120);
  static const Color darkSurface = Color(0xFF142035);
  static const Color darkCard = Color(0xFF1A2538);
  static const Color darkElevated = Color(0xFF1D2D47);
  static const Color darkPrimary = Color(0xFF2EACBA); // brighter teal for dark
  static const Color darkDivider = Color(0xFF1E2D42);
  static const Color darkText = Color(0xFFE2EEF8);
  static const Color darkTextSub = Color(0xFF8BAEC8);
  static const Color darkAppBar = Color(0xFF111E30);
  static const Color darkBorder = Color(0xFF2A3D56); // borders, outlines
  static const Color darkTextTertiary = Color(0xFF5A7A96); // placeholder / hint / icon
  static const Color darkFlashHighlight = Color(0xFF0E3A2E); // search-bar flash

  // ── Light mode explicit palette ───────────────────────────────────────────
  static const Color lightCard = Colors.white; // card & sheet bg
  static const Color lightSubtle = Color(0xFFF3F7F8); // input fill, subtle bg
  static const Color lightBorder = Color(0xFFDDE6E8); // field borders
  static const Color lightPhraseRow = Color(0xFFF9F7F4); // phrase-row bg (same as backgroundSand)
  static const Color lightTextPrimary = Color(0xFF1A2B2C); // primary text (dark teal, not grey)
  static const Color lightStationText = Color(0xFF3D5A60); // station name text in picker
  static const Color lightBodyText = Color(0xFF3E5055); // body / description text

  // ─────────────────────────────────────────────────────────────────────────
  // LIGHT THEME
  // ─────────────────────────────────────────────────────────────────────────

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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  // ─────────────────────────────────────────────────────────────────────────
  // DARK THEME  — deep midnight navy, gold accents, Nile cyan
  // ─────────────────────────────────────────────────────────────────────────

  static ThemeData darkTheme() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: darkPrimary,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF0E4A54),
      onPrimaryContainer: Color(0xFFB3EBF2),
      secondary: secondaryDesert,
      onSecondary: Color(0xFF3E2E00),
      secondaryContainer: Color(0xFF4A3800),
      onSecondaryContainer: Color(0xFFF7D488),
      tertiary: accentGold,
      onTertiary: Color(0xFF3D2E00),
      tertiaryContainer: Color(0xFF4A3900),
      onTertiaryContainer: accentGold,
      error: error,
      onError: Colors.white,
      errorContainer: Color(0xFF7A1A0A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: darkSurface,
      onSurface: darkText,
      surfaceContainerHighest: darkElevated,
      onSurfaceVariant: darkTextSub,
      outline: darkBorder,
      outlineVariant: Color(0xFF1A2D42),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: darkText,
      onInverseSurface: darkBackground,
      inversePrimary: primaryNile,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: darkBackground,
      fontFamily: 'Tajawal',
      textTheme: _buildTextTheme(),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 4,
        backgroundColor: darkAppBar,
        foregroundColor: darkText,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: darkText,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: darkDivider),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: darkPrimary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: const TextStyle(color: darkTextTertiary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkPrimary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      dividerTheme: const DividerThemeData(
        color: darkDivider,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkElevated,
        selectedColor: const Color(0xFF0E4A54),
        disabledColor: darkCard,
        labelStyle: const TextStyle(color: darkText),
        side: const BorderSide(color: darkBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: darkSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkAppBar,
        indicatorColor: const Color(0xFF0E4A54),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(color: darkText, fontSize: 12, fontFamily: 'Tajawal'),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        tileColor: Colors.transparent,
        iconColor: darkTextSub,
        textColor: darkText,
      ),
      iconTheme: const IconThemeData(color: darkText),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: darkElevated,
        contentTextStyle: TextStyle(color: darkText, fontFamily: 'Tajawal'),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────

  static TextTheme _buildTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
          fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5),
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

  // ─────────────────────────────────────────────────────────────────────────
  // Convenience getters — call Theme.of(context) once, share everywhere.
  // ─────────────────────────────────────────────────────────────────────────

  static Color cardBg(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  static Color subtleBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkElevated
          : Colors.grey.shade50;

  static Color inputBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkCard
          : Colors.white;

  static Color borderColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkBorder
          : Colors.grey.shade200;

  static Color textPrimary(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkTextSub
          : Colors.grey.shade600;

  static Color textTertiary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkTextTertiary
          : Colors.grey.shade400;

  static Color divider(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkDivider
          : Colors.grey.shade200;

  static Color headerGradientStart(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF0A1628)
          : const Color(0xFF0D3B52);

  static Color lineColor(String lineId, {double opacity = 1.0}) {
    switch (lineId.toLowerCase()) {
      case '1':
        return line1.withValues(alpha: opacity);
      case '2':
        return line2.withValues(alpha: opacity);
      case '3':
      case '3a':
      case '3b':
        return line3.withValues(alpha: opacity);
      case '4':
        return line4.withValues(alpha: opacity);
      case 'lrt':
        return lrt.withValues(alpha: opacity);
      default:
        return primaryNile.withValues(alpha: opacity);
    }
  }
}
