import 'package:flutter/material.dart';

class Helper {
  static const Color ink = Color(0xFF101828);
  static const Color muted = Color(0xFF667085);
  static const Color softText = Color(0xFF98A2B3);
  static const Color backgroundColor = Color(0xFFF4F7FB);
  static const Color darkBackground = Color(0xFF050505);
  static const Color cardColor = Colors.white;
  static const Color lineColor = Color(0xFFE4E7EC);
  static const Color primary = Color(0xFF1769FF);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF97316);
  static const Color danger = Color(0xFFEF4444);
  static const Color mapFill = Color(0xFFE8EDF2);

  static const BorderRadiusGeometry cardRadius = BorderRadius.all(
    Radius.circular(16),
  );

  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static ThemeData get theme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      surface: cardColor,
      error: danger,
    );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundColor,
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: cardRadius),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: lineColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: lineColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: ink,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
        titleLarge: TextStyle(
          color: ink,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
        bodyMedium: TextStyle(color: ink, fontSize: 15, height: 1.35),
      ),
    );
  }
}
