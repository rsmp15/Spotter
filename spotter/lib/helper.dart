import 'package:flutter/material.dart';
import 'core/theme/colors.dart';

class Helper {
  // Spott Design System v2 Premium tokens
  static const Color ink = SpottColors.textPrimary;
  static const Color muted = SpottColors.textSecondary;
  static const Color softText = SpottColors.textSecondary;
  static const Color backgroundColor = SpottColors.background;
  static const Color darkBackground = Color(0xFF09090B); 
  static const Color cardColor = SpottColors.surface1;
  static const Color lineColor = SpottColors.border;
 
  static const Color primary = Color(0xFFE60023); // Pinterest Red Primary Action
  static const Color accent = Color(0xFF6366F1); // Indigo Community Accent
  static const Color success = SpottColors.success; 
  static const Color warning = SpottColors.warning; 
  static const Color danger = Color(0xFFEF4444); 
  static const Color mapFill = SpottColors.surface1;
 
  // Internal background levels
  static const Color bgMid = SpottColors.surface2; 
  static const Color bgSurf = SpottColors.surface2; 
  static const Color bgCard = SpottColors.surface1; 
 
  // Premium text shades
  static const Color textHi = SpottColors.textPrimary; 
  static const Color textMed = SpottColors.textSecondary; 
  static const Color textLow = SpottColors.textTertiary; 
  static const Color textMute = SpottColors.textMuted; 
 
  // Transparent/Glass layers
  static const Color glass = SpottColors.glassSurface; 
  static const Color glassHi = SpottColors.glassHigh; 
  static const Color glassEdge = SpottColors.border; 
 
  static const Color canvasSoft = SpottColors.surface2;
  static const Color canvasSofter = SpottColors.surface1;
  static const Color blackElevated = SpottColors.surface1;
  static const Color hairline = SpottColors.border;
 
  static const BorderRadiusGeometry cardRadius = BorderRadius.all(
    Radius.circular(24), // 24px corner radii as requested
  );
 
  static const List<BoxShadow> premiumShadows = [
    BoxShadow(color: Color(0x66000000), blurRadius: 16, offset: Offset(0, 4)),
  ];

  static TextStyle get titleStyle => TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: SpottColors.textPrimary,
    fontFamily: 'Inter',
  );

  // Context-aware dynamic color getters for proper theme support
  static Color inkColor(BuildContext context) => textHi;

  static Color mutedColor(BuildContext context) => textMed;

  static Color cardBg(BuildContext context) => bgCard;

  static Color line(BuildContext context) => lineColor;

  static Color canvasSoftColor(BuildContext context) => bgSurf;

  static Color canvasSofterColor(BuildContext context) => bgMid;

  static ThemeData get theme => buildTheme(isDarkMode: true);

  static ThemeData buildTheme({required bool isDarkMode}) {
    SpottColors.updateTheme(isDarkMode);

    final primaryColor = primary;
    final bg = backgroundColor;
    final cardBgColor = cardColor;
    final lineBorder = lineColor;
    final textColor = textHi;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      primary: primaryColor,
      secondary: accent,
      surface: cardBgColor,
      error: danger,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
    );

    return ThemeData(
      colorScheme: colorScheme,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
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
            borderRadius: BorderRadius.circular(18), // 18px radius buttons
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
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgSurf,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: lineBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: lineBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
      ),
      textTheme: TextTheme(
        headlineSmall: TextStyle(
          color: textColor,
          fontSize: 26,
          fontWeight: FontWeight.bold,
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
          color: textMed,
          fontSize: 14,
          height: 1.35,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
