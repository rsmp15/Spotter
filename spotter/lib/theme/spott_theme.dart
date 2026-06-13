import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';






class SpottTheme {
  // Brand Colors mapped to canonical tokens
  static const Color primary = DSColors.primary;
  static const Color primaryLight = DSColors.primaryLight;

  // Backgrounds & Surfaces
  static const Color background = DSColors.background;
  static const Color surface = DSColors.surface;
  static const Color card = DSColors.surfaceVariant;
  static final Color glassmorphismColor = Color(0x1A000000).withValues(alpha: 0.1);

  // Text Colors
  static const Color textPrimary = DSColors.textPrimary;
  static const Color textSecondary = DSColors.textSecondary;

  // Status Colors
  static const Color success = DSColors.success;
  static const Color warning = DSColors.warning;

  // Radii
  static const double radiusSmall = DSRadius.sm;
  static const double radiusMedium = DSRadius.lg;
  static const double radiusLarge = DSRadius.xl;
  static const double radiusXLarge = DSRadius.xxl;

  static BorderRadius get borderRadiusMedium =>
      BorderRadius.circular(DSRadius.lg);
  static BorderRadius get borderRadiusLarge =>
      BorderRadius.circular(DSRadius.xl);
  static BorderRadius get borderRadiusXLarge =>
      BorderRadius.circular(DSRadius.xxl);

  // Padding & Spacing
  static const double spacingSmall = DSSpacing.sm;
  static const double spacingMedium = DSSpacing.md;
  static const double spacingLarge = DSSpacing.lg;
  static const double spacingXLarge = DSSpacing.xl;

  // Shadows
  static List<BoxShadow> get premiumShadow => DSShadows.elevation2;
  static List<BoxShadow> get glowingShadow => DSShadows.elevation2;

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
    return (!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST')
            ? const TextTheme()
            : GoogleFonts.interTextTheme())
        .copyWith(
      displayLarge: DSTypography.displayLarge.copyWith(color: textPrimary),
      displayMedium: DSTypography.headline.copyWith(color: textPrimary),
      headlineLarge: DSTypography.headline.copyWith(color: textPrimary),
      headlineMedium: DSTypography.headline.copyWith(color: textPrimary),
      titleLarge: DSTypography.titleLarge.copyWith(color: textPrimary),
      titleMedium: DSTypography.titleLarge.copyWith(color: textPrimary),
      bodyLarge: DSTypography.bodyLarge.copyWith(color: textSecondary),
      bodyMedium: DSTypography.body.copyWith(color: textSecondary),
      labelLarge: DSTypography.labelLarge.copyWith(color: textPrimary),
      labelMedium: DSTypography.caption.copyWith(color: textSecondary),
    );
  }
}
