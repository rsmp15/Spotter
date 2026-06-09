import 'package:flutter/material.dart';

class ThemeColor extends Color {
  final int dark;
  final int light;

  const ThemeColor(this.dark, this.light) : super(dark);

  @override
  int get value => SpottColors.isDark ? dark : light;
}

class SpottColors {
  static bool isDark = false;

  // ── Backgrounds & Surfaces ──────────────────────────────────────────
  static const Color background = Color(0xFFF8F8F8);
  static const Color backgroundElevated = Color(0xFFFFFFFF);
  static const Color surface1 = Color(0xFFFFFFFF);
  static const Color surface2 = Color(0xFFF5F5F5); // Slightly off-white for depth / chips
  static const Color surface3 = Color(0xFFFFFFFF);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color surface4 = Color(0xFFFFFFFF);
  static const Color surfaceContainer = Color(0xFFFFFFFF);

  // ── Primary Palette & Actions ────────────────────────────────────────
  static const Color primary = Color(0xFFD84E55); // redBus Red
  static const Color primaryDark = Color(0xFFB73D45); // redBus Dark Red
  static const Color primaryLight = Color(0xFFE57373);
  static const Color primarySoft = Color(0xFFFFEBEE);

  // ── Interactive State Tokens ──────────────────────────────────────────
  static const Color primaryPressed = Color(0xFF9E2A30); // Darker red on press
  static const Color primaryHover = Color(0xFFE55D63); // Lighter red on hover
  static const Color disabled = Color(0xFFE5E7EB);
  static const Color disabledText = Color(0xFF9CA3AF);
  static const Color overlayHover = Color(0x0A000000);
  static const Color overlayPressed = Color(0x1A000000);

  // ── Accent (Marketplace & Community Accent) ──────────────────────────
  static const Color accentPurple = Color(0xFFB73D45); // redBus Secondary Dark Red
  static const Color accentPurpleSoft = Color(0xFFFFEBEE);
  static const Color accentSecondaryContainer = Color(0xFFD84E55);

  // ── Semantic Status & Trust (WCAG Contrast Safe) ──────────────────────────
  static const Color success = Color(0xFF16A34A); // Emerald Green (darkened slightly for light contrast)
  static const Color successSoft = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFD97706); // Amber (darkened for light contrast)
  static const Color warningSoft = Color(0xFFFEF3C7);
  static const Color danger = Color(0xFFDC2626); // Red (darkened for light contrast)
  static const Color dangerSoft = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF2563EB); // Blue (darkened for light contrast)
  static const Color infoSoft = Color(0xFFDBEAFE);

  // ── Typography (Contrast ratios >= 4.5:1) ──────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF111827); // Dark gray (almost black)
  static const Color textSecondary = Color(0xFF4B5563); // Medium gray
  static const Color textTertiary = Color(0xFF6B7280); // Light gray
  static const Color textMuted = Color(0xFF9CA3AF); // Muted gray

  // ── Icons ───────────────────────────────────────────────────────────
  static const Color iconPrimary = Color(0xFF111827);
  static const Color iconSecondary = Color(0xFF4B5563);

  // ── Inputs & Cards ──────────────────────────────────────────────────
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // ── Offer / Banner Accent Colors ─────────────────────────────────────
  static const Color offerRed = Color(0xFFE53935);
  static const Color offerBlue = Color(0xFF1976D2);
  static const Color offerGreen = Color(0xFF43A047);
  static const Color offerPurple = Color(0xFF8E24AA);

  // ── Glass & Borders ─────────────────────────────────────────────────
  static const Color glassSurface = Color(0xFFFFFFFF);
  static const Color glassHigh = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderSubtle = Color(0xFFF3F4F6);
  static const Color divider = Color(0xFFE5E7EB);

  // ── Overlay & Scrim ─────────────────────────────────────────────────
  static const Color overlay = Color(0xCCF8F8F8);
  static const Color scrim = Color(0x4D000000);

  // ── Shimmer / Skeleton Loading ──────────────────────────────────────
  static const Color shimmerBase = Color(0xFFE5E7EB);
  static const Color shimmerHighlight = Color(0xFFF3F4F6);

  // ── Trust & Verification ────────────────────────────────────────────
  static const Color trustVerified = Color(0xFF16A34A);
  static const Color trustPremium = Color(0xFFD97706);
  static const Color trustBadge = Color(0xFF2563EB);

  // ── Gradient Endpoints ──────────────────────────────────────────────
  static const Color gradientStart = Color(0xFFFFFFFF);
  static const Color gradientEnd = Color(0xFFF8F8F8);
  static const Color heroGradientStart = Color(0xFFFFFFFF);
  static const Color heroGradientEnd = Color(0xFFF8F8F8);

  static void updateTheme(bool dark) {
    isDark = false; // Always light theme for premium feel
  }
}
