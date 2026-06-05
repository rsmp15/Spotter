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
  static const Color background = ThemeColor(0xFFF8F8F8, 0xFFF8F8F8);
  static const Color backgroundElevated = ThemeColor(0xFFFFFFFF, 0xFFFFFFFF);
  static const Color surface1 = ThemeColor(0xFFFFFFFF, 0xFFFFFFFF);
  static const Color surface2 = ThemeColor(0xFFF5F5F5, 0xFFF5F5F5); // Slightly off-white for depth / chips
  static const Color surface3 = ThemeColor(0xFFFFFFFF, 0xFFFFFFFF);
  static const Color cardSurface = ThemeColor(0xFFFFFFFF, 0xFFFFFFFF);
  static const Color surface4 = ThemeColor(0xFFFFFFFF, 0xFFFFFFFF);
  static const Color surfaceContainer = ThemeColor(0xFFFFFFFF, 0xFFFFFFFF);

  // ── Primary Palette & Actions ────────────────────────────────────────
  static const Color primary = Color(0xFFD84E55); // RedBus Red
  static const Color primaryDark = Color(0xFFB73D45); // RedBus Dark Red
  static const Color primarySoft = ThemeColor(0xFFFFEBEE, 0xFFFFEBEE);

  // ── Accent (Marketplace & Community Accent) ──────────────────────────
  static const Color accentPurple = Color(0xFFB73D45); // RedBus Secondary Dark Red
  static const Color accentPurpleSoft = ThemeColor(0xFFFFEBEE, 0xFFFFEBEE);
  static const Color accentSecondaryContainer = Color(0xFFD84E55);

  // ── Semantic Status & Trust ──────────────────────────────────────────
  static const Color success = Color(0xFF22C55E); // Emerald Green
  static const Color successSoft = ThemeColor(0xFFDCFCE7, 0xFFDCFCE7);
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color warningSoft = ThemeColor(0xFFFEF3C7, 0xFFFEF3C7);
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerSoft = ThemeColor(0xFFFEE2E2, 0xFFFEE2E2);
  static const Color info = Color(0xFF2196F3); // Blue for info
  static const Color infoSoft = ThemeColor(0xFFE3F2FD, 0xFFE3F2FD);

  // ── Typography ──────────────────────────────────────────────────────
  static const Color textPrimary = ThemeColor(0xFF1D1D1D, 0xFF1D1D1D);
  static const Color textSecondary = ThemeColor(0xFF666666, 0xFF666666);
  static const Color textTertiary = ThemeColor(0xFF9E9E9E, 0xFF9E9E9E);
  static const Color textMuted = ThemeColor(0xFF9E9E9E, 0xFF9E9E9E);

  // ── Glass & Borders ─────────────────────────────────────────────────
  static const Color glassSurface = ThemeColor(0xFFFFFFFF, 0xFFFFFFFF);
  static const Color glassHigh = ThemeColor(0xFFFFFFFF, 0xFFFFFFFF);
  static const Color border = ThemeColor(0xFFEAEAEA, 0xFFEAEAEA);
  static const Color borderSubtle = ThemeColor(0xFFEAEAEA, 0xFFEAEAEA);
  static const Color divider = ThemeColor(0xFFEAEAEA, 0xFFEAEAEA);

  // ── Overlay & Scrim ─────────────────────────────────────────────────
  static const Color overlay = ThemeColor(0xCCF8F8F8, 0xCCF8F8F8);
  static const Color scrim = ThemeColor(0x4D000000, 0x4D000000);

  // ── Shimmer / Skeleton Loading ──────────────────────────────────────
  static const Color shimmerBase = ThemeColor(0xFFE6E8F0, 0xFFE6E8F0);
  static const Color shimmerHighlight = ThemeColor(0xFFF5F6FA, 0xFFF5F6FA);

  // ── Trust & Verification ────────────────────────────────────────────
  static const Color trustVerified = ThemeColor(0xFF22C55E, 0xFF22C55E);
  static const Color trustPremium = Color(0xFFF59E0B);
  static const Color trustBadge = ThemeColor(0xFF2196F3, 0xFF2196F3);

  // ── Gradient Endpoints ──────────────────────────────────────────────
  static const Color gradientStart = ThemeColor(0xFFFFFFFF, 0xFFFFFFFF);
  static const Color gradientEnd = ThemeColor(0xFFF8F8F8, 0xFFF8F8F8);
  static const Color heroGradientStart = ThemeColor(0xFFFFFFFF, 0xFFFFFFFF);
  static const Color heroGradientEnd = ThemeColor(0xFFF8F8F8, 0xFFF8F8F8);

  static void updateTheme(bool dark) {
    isDark = false; // Always light theme for RedBus premium feel
  }
}
