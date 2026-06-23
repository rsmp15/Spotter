import 'package:flutter/material.dart';
import 'design_system/design_system.dart';

class Helper {
  // Spott Design System v2 Premium tokens
  static const Color ink = DSColors.textPrimary;
  static const Color muted = DSColors.textSecondary;
  static const Color softText = DSColors.textSecondary;
  static const Color backgroundColor = DSColors.background;
  static const Color darkBackground = DSColors.background; // Map to background for premium consistency
  static const Color cardColor = DSColors.card;
  static const Color lineColor = DSColors.border;
 
  static const Color primary = DSColors.primary; // RedBus Red
  static const Color accent = DSColors.primaryDark; // RedBus Dark Red
  static const Color success = DSColors.success; 
  static const Color warning = DSColors.warning; 
  static const Color danger = DSColors.danger; 
  static const Color mapFill = DSColors.surface;
 
  // Internal background levels
  static const Color bgMid = DSColors.surfaceVariant; 
  static const Color bgSurf = DSColors.surface; 
  static const Color bgCard = DSColors.card; 
 
  // Premium text shades
  static const Color textHi = DSColors.textPrimary; 
  static const Color textMed = DSColors.textSecondary; 
  static const Color textLow = DSColors.textTertiary; 
  static const Color textMute = DSColors.textMuted; 
 
  // Transparent/Glass layers
  static const Color glass = DSColors.glass; 
  static const Color glassHi = DSColors.glassHigh; 
  static const Color glassEdge = DSColors.glassBorder; 
 
  static const Color canvasSoft = DSColors.surfaceVariant;
  static const Color canvasSofter = DSColors.surface;
  static const Color blackElevated = DSColors.surface;
  static const Color hairline = DSColors.border;
 
  static const BorderRadiusGeometry cardRadius = BorderRadius.all(
    Radius.circular(DSRadius.card),
  );
  
  static final List<BoxShadow> premiumShadows = DSShadows.elevation1;

  static TextStyle get titleStyle => DSTypography.displayLarge.copyWith(
    fontSize: 26,
    color: DSColors.textPrimary,
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
    return isDarkMode ? AppTheme.dark : AppTheme.light;
  }
}

