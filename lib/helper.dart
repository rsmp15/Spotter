import 'package:flutter/material.dart';

class Helper {
  static const Color ink = Color(0xFF000000);
  static const Color muted = Color(0xFF5E5E5E);
  static const Color softText = Color(0xFF8F8F8F);
  static const Color backgroundColor = Color(0xFFF9FAFB);
  static const Color darkBackground = Color(0xFF000000);
  static const Color cardColor = Colors.white;
  static const Color lineColor = Color(0xFFE2E8F0);
  static const Color primary = Color(0xFF000000);
  static const Color success = Color(0xFF000000); // High contrast elegant black
  static const Color warning = Color(0xFFF97316);
  static const Color danger = Color(0xFFEF4444);
  static const Color mapFill = Color(0xFFE2E8F0);

  static const BorderRadiusGeometry cardRadius = BorderRadius.all(
    Radius.circular(16),
  );

  static const List<BoxShadow> premiumShadows = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 15, offset: Offset(0, 10)),
    BoxShadow(color: Color(0x05000000), blurRadius: 5, offset: Offset(0, 2)),
  ];

  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static ThemeData get theme => buildTheme(isDarkMode: false);

  static ThemeData buildTheme({required bool isDarkMode}) {
    final primaryColor = isDarkMode ? Colors.white : primary;
    final bg = isDarkMode ? const Color(0xFF0C0F14) : backgroundColor;
    final cardBg = isDarkMode ? const Color(0xFF131722) : cardColor;
    final line = isDarkMode ? const Color(0xFF1E293B) : lineColor;
    final textColor = isDarkMode ? Colors.white : ink;

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
        shape: RoundedRectangleBorder(borderRadius: cardRadius),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: isDarkMode ? Colors.white : primary,
          foregroundColor: isDarkMode ? Colors.black : Colors.white,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isDarkMode ? const Color(0xFF38BDF8) : primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDarkMode ? const Color(0xFF38BDF8) : primary,
            width: 1.5,
          ),
        ),
      ),
      textTheme: TextTheme(
        headlineSmall: TextStyle(
          color: textColor,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
        titleLarge: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
        bodyMedium: TextStyle(color: textColor, fontSize: 15, height: 1.35),
      ),
    );
  }
}
