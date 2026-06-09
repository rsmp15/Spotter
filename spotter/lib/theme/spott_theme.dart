import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/colors.dart';
import '../core/theme/radius.dart';
import '../core/theme/spacing.dart';
import '../core/theme/shadows.dart';
import '../core/theme/typography.dart';

class SpottTheme {
  // Brand Colors mapped to canonical tokens
  static const Color primary = SpottColors.primary;
  static const Color primaryLight = SpottColors.primaryLight;

  // Backgrounds & Surfaces
  static const Color background = SpottColors.background;
  static const Color surface = SpottColors.surface1;
  static const Color card = SpottColors.surface2;
  static final Color glassmorphismColor = SpottColors.overlayPressed.withValues(alpha: 0.1);

  // Text Colors
  static const Color textPrimary = SpottColors.textPrimary;
  static const Color textSecondary = SpottColors.textSecondary;

  // Status Colors
  static const Color success = SpottColors.success;
  static const Color warning = SpottColors.warning;

  // Radii
  static const double radiusSmall = SpottRadius.sm;
  static const double radiusMedium = SpottRadius.lg;
  static const double radiusLarge = SpottRadius.xl;
  static const double radiusXLarge = SpottRadius.xxl;

  static BorderRadius get borderRadiusMedium =>
      BorderRadius.circular(SpottRadius.lg);
  static BorderRadius get borderRadiusLarge =>
      BorderRadius.circular(SpottRadius.xl);
  static BorderRadius get borderRadiusXLarge =>
      BorderRadius.circular(SpottRadius.xxl);

  // Padding & Spacing
  static const double spacingSmall = SpottSpacing.sm;
  static const double spacingMedium = SpottSpacing.md;
  static const double spacingLarge = SpottSpacing.lg;
  static const double spacingXLarge = SpottSpacing.xl;

  // Shadows
  static List<BoxShadow> get premiumShadow => SpottShadows.elevation2;
  static List<BoxShadow> get glowingShadow => SpottShadows.glowPrimary;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [surface, background],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Typography mapped to canonical text styles
  static TextTheme get textTheme {
    return GoogleFonts.interTextTheme().copyWith(
      displayLarge: SpottTextStyles.displayLarge.copyWith(color: textPrimary),
      displayMedium: SpottTextStyles.display.copyWith(color: textPrimary),
      headlineLarge: SpottTextStyles.display.copyWith(color: textPrimary),
      headlineMedium: SpottTextStyles.headline.copyWith(color: textPrimary),
      titleLarge: SpottTextStyles.title.copyWith(color: textPrimary),
      titleMedium: SpottTextStyles.titleSmall.copyWith(color: textPrimary),
      bodyLarge: SpottTextStyles.bodyLarge.copyWith(color: textSecondary),
      bodyMedium: SpottTextStyles.body.copyWith(color: textSecondary),
      labelLarge: SpottTextStyles.label.copyWith(color: textPrimary),
      labelMedium: SpottTextStyles.caption.copyWith(color: textSecondary),
    );
  }
}
