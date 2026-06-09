import 'package:flutter/material.dart';
import 'core/theme/colors.dart';
import 'core/theme/radius.dart';
import 'core/theme/spacing.dart';
import 'core/theme/shadows.dart';
import 'core/theme/typography.dart';

class Helper {
  // Spott Design System v2 Premium tokens
  static const Color ink = SpottColors.textPrimary;
  static const Color muted = SpottColors.textSecondary;
  static const Color softText = SpottColors.textSecondary;
  static const Color backgroundColor = SpottColors.background;
  static const Color darkBackground = SpottColors.background; // Map to background for premium consistency
  static const Color cardColor = SpottColors.surface1;
  static const Color lineColor = SpottColors.border;
 
  static const Color primary = SpottColors.primary; // RedBus Red
  static const Color accent = SpottColors.primaryDark; // RedBus Dark Red
  static const Color success = SpottColors.success; 
  static const Color warning = SpottColors.warning; 
  static const Color danger = SpottColors.danger; 
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
    Radius.circular(SpottRadius.card),
  );
  
  static final List<BoxShadow> premiumShadows = SpottShadows.elevation1;

  static TextStyle get titleStyle => SpottTextStyles.displayLarge.copyWith(
    fontSize: 26,
    color: SpottColors.textPrimary,
  );

  // Context-aware dynamic color getters for proper theme support
  static Color inkColor(BuildContext context) => textHi;

  static Color mutedColor(BuildContext context) => textMed;

  static Color cardBg(BuildContext context) => bgCard;

  static Color line(BuildContext context) => lineColor;

  static Color canvasSoftColor(BuildContext context) => bgSurf;

  static Color canvasSofterColor(BuildContext context) => bgMid;

  static ThemeData get theme => buildTheme(isDarkMode: false); // Default to light theme

  static ThemeData buildTheme({required bool isDarkMode}) {
    // Force Light Premium style as Spott is designed for high accessibility
    // and premium branding, maintaining a light mode primary appearance.
    SpottColors.updateTheme(false);

    final primaryColor = SpottColors.primary;
    final bg = SpottColors.background;
    final cardBgColor = SpottColors.surface1;
    final lineBorder = SpottColors.border;
    final textColor = SpottColors.textPrimary;
    final textMed = SpottColors.textSecondary;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: SpottColors.primary,
      primary: primaryColor,
      secondary: SpottColors.primaryDark,
      surface: cardBgColor,
      error: SpottColors.danger,
      brightness: Brightness.light,
    );

    return ThemeData(
      colorScheme: colorScheme,
      brightness: Brightness.light,
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
          borderRadius: BorderRadius.circular(SpottRadius.card),
          side: BorderSide(color: lineBorder, width: 1.0),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SpottRadius.button),
          ),
          backgroundColor: SpottColors.primary,
          foregroundColor: Colors.white,
          textStyle: SpottTextStyles.label.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: SpottColors.primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SpottColors.surface2,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SpottSpacing.s16,
          vertical: SpottSpacing.s16,
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(SpottRadius.inputs)),
          borderSide: BorderSide(color: lineBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(SpottRadius.inputs)),
          borderSide: BorderSide(color: lineBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(SpottRadius.inputs)),
          borderSide: BorderSide(color: SpottColors.primary, width: 1.5),
        ),
      ),
      textTheme: TextTheme(
        headlineSmall: SpottTextStyles.display.copyWith(
          color: textColor,
          fontSize: 26,
        ),
        titleLarge: SpottTextStyles.titleSmall.copyWith(
          color: textColor,
          fontSize: 20,
        ),
        bodyMedium: SpottTextStyles.body.copyWith(
          color: textMed,
          fontSize: 14,
          height: 1.35,
        ),
      ),
    );
  }
}
