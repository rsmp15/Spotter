import 'package:flutter/material.dart';

class Helper {
  static const Color ink = Color(0xFF000000);
  static const Color muted = Color(0xFF5E5E5E);
  static const Color softText = Color(0xFFAFAFAF);
  static const Color backgroundColor = Color(0xFFF9F9F9);
  static const Color darkBackground = Color(0xFF0B0B0B);
  static const Color cardColor = Colors.white;
  static const Color lineColor = Color(0xFFE2E2E2);

  // Urban Mobility Parking Hub / SPOTT design tokens.
  static const Color primary = Color(0xFF000000);
  static const Color success = Color(0xFF166534);
  static const Color warning = Color(0xFF8B5E00);
  static const Color danger = Color(0xFFB42318);
  static const Color mapFill = Color(0xFFEDEDED);

  static const Color canvasSoft = Color(0xFFEFEFEF);
  static const Color canvasSofter = Color(0xFFF3F3F3);
  static const Color blackElevated = Color(0xFF282828);
  static const Color hairline = Color(0xFF4B4B4B);

  static const BorderRadiusGeometry cardRadius = BorderRadius.all(
    Radius.circular(16),
  );

  static const List<BoxShadow> premiumShadows = [
    BoxShadow(color: Color(0x0F000000), blurRadius: 16, offset: Offset(0, 8)),
  ];

  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontFamily: 'Inter',
  );

  // Context-aware dynamic color getters for proper dark theme support
  static Color inkColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? Colors.white : ink;

  static Color mutedColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFAFAFAF)
          : muted;

  static Color cardBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1E1E24)
          : cardColor;

  static Color line(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF2C2C2C)
          : lineColor;

  static Color canvasSoftColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1E293B)
          : canvasSoft;

  static Color canvasSofterColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1A1A1A)
          : canvasSofter;

  static ThemeData get theme => buildTheme(isDarkMode: false);

  static ThemeData buildTheme({required bool isDarkMode}) {
    final primaryColor = isDarkMode ? Colors.white : primary;
    final bg = isDarkMode ? darkBackground : backgroundColor;
    final cardBg = isDarkMode ? const Color(0xFF121212) : cardColor;
    final line = isDarkMode ? const Color(0xFF2C2C2C) : lineColor;
    final textColor = isDarkMode ? const Color(0xFFE5E2E1) : ink;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      primary: primaryColor,
      surface: cardBg,
      error: danger,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
    );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: bg,
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: cardRadius,
          side: isDarkMode
              ? BorderSide(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1.0,
                )
              : BorderSide(color: line, width: 1.0),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              999,
            ), // Fully pill-shaped buttons
          ),
          backgroundColor: isDarkMode ? Colors.white : primary,
          foregroundColor: isDarkMode ? ink : Colors.white,
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isDarkMode ? Colors.white : primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.white : primary,
            width: 1.5,
          ),
        ),
      ),
      textTheme: TextTheme(
        headlineSmall: TextStyle(
          color: textColor,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          fontFamily: 'Inter',
        ),
        titleLarge: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          fontFamily: 'Inter',
        ),
        bodyMedium: TextStyle(
          color: textColor,
          fontSize: 15,
          height: 1.35,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
