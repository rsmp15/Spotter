import 'package:flutter/material.dart';

class Helper {
  // Standard ink & soft colors - forced Light theme
  static const Color ink = Color(0xFF111827);
  static const Color muted = Color(0xFF6B7280);
  static const Color softText = Color(0xFF9CA3AF);
  static const Color backgroundColor = Color(0xFFF8F9FC);
  static const Color darkBackground = Color(0xFFF8F9FC); 
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color lineColor = Color(0xFFE6E8F0);
 
  // Spott Design System v2 Premium tokens
  static const Color primary = Color(0xFFEE334A); // Primary Action
  static const Color accent = Color(0xFF2563EB); // Route Accent Blue
  static const Color success = Color(0xFF22C55E); 
  static const Color warning = Color(0xFFF59E0B); 
  static const Color danger = Color(0xFFEF4444); 
  static const Color mapFill = Color(0xFFFFFFFF);
 
  // Figma internal background levels
  static const Color bgMid = Color(0xFFFFFFFF); 
  static const Color bgSurf = Color(0xFFF5F6FA); 
  static const Color bgCard = Color(0xFFFFFFFF); 
 
  // Premium text shades
  static const Color textHi = Color(0xFF111827); 
  static const Color textMed = Color(0xFF6B7280); 
  static const Color textLow = Color(0xFF9CA3AF); 
  static const Color textMute = Color(0xFF9CA3AF); 
 
  // Transparent/Glass layers (now flattened to solid white/light grey surfaces)
  static const Color glass = Color(0xFFFFFFFF); 
  static const Color glassHi = Color(0x0D000000); 
  static const Color glassEdge = Color(0xFFE6E8F0); 
 
  static const Color canvasSoft = Color(0xFFF5F6FA);
  static const Color canvasSofter = Color(0xFFFFFFFF);
  static const Color blackElevated = Color(0xFFFFFFFF);
  static const Color hairline = Color(0xFFE6E8F0);
 
  static const BorderRadiusGeometry cardRadius = BorderRadius.all(
    Radius.circular(16), // 16px corner radii
  );
 
  static const List<BoxShadow> premiumShadows = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
  ];

  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Color(0xFF111827),
    fontFamily: 'Inter',
  );

  // Context-aware dynamic color getters for proper theme support
  static Color inkColor(BuildContext context) => textHi;

  static Color mutedColor(BuildContext context) => textMed;

  static Color cardBg(BuildContext context) => bgCard;

  static Color line(BuildContext context) => lineColor;

  static Color canvasSoftColor(BuildContext context) => bgSurf;

  static Color canvasSofterColor(BuildContext context) => bgMid;

  static ThemeData get theme => buildTheme(isDarkMode: false);

  static ThemeData buildTheme({required bool isDarkMode}) {
    final primaryColor = primary;
    const bg = backgroundColor;
    const cardBgColor = cardColor;
    const lineBorder = lineColor;
    const textColor = textHi;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      primary: primaryColor,
      secondary: accent,
      surface: cardBgColor,
      error: danger,
      brightness: Brightness.light,
    );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: bg,
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: const CardThemeData(
        color: cardBgColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: cardRadius,
          side: BorderSide(color: lineBorder, width: 1.0),
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
          backgroundColor: primary,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: bgSurf,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: lineBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: lineBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: textColor,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
          fontFamily: 'Inter',
        ),
        titleLarge: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
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
