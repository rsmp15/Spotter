import 'package:flutter/material.dart';

class ThemeColor extends Color {
  final int dark;
  final int light;

  const ThemeColor(this.dark, this.light) : super(dark);

  @override
  int get value => SpottColors.isDark ? dark : light;
}

class SpottColors {
  static bool isDark = true;

  // ── Backgrounds & Surfaces ──────────────────────────────────────────
  static const Color background = ThemeColor(0xFF09090B, 0xFFF8F9FC);
  static const Color backgroundElevated = ThemeColor(0xFF111318, 0xFFFFFFFF);
  static const Color surface1 = ThemeColor(0xFF111318, 0xFFFFFFFF);
  static const Color surface2 = ThemeColor(0xFF161A22, 0xFFF5F6FA);
  static const Color surface3 = ThemeColor(0xFF111318, 0xFFFFFFFF);
  static const Color cardSurface = ThemeColor(0xFF111318, 0xFFFFFFFF);
  static const Color surface4 = ThemeColor(0xFF222530, 0xFFE6E8F0);

  // ── Primary Palette & Actions ────────────────────────────────────────
  static const Color primary = Color(0xFFE60023); // Pinterest Red CTA
  static const Color primaryDark = Color(0xFFC3001E); // Primary CTA Hover
  static const Color primarySoft = ThemeColor(0x1AE60023, 0x0DE60023);

  // ── Accent (Marketplace & Community Accent) ──────────────────────────
  static const Color accentPurple = Color(0xFF6366F1); // Indigo Community Accent
  static const Color accentPurpleSoft = ThemeColor(0x1A6366F1, 0x0D6366F1);

  // ── Semantic Status & Trust ──────────────────────────────────────────
  static const Color success = Color(0xFF10B981); // Trust Verified Green
  static const Color successSoft = ThemeColor(0x1A10B981, 0x0D10B981);
  static const Color warning = Color(0xFFF59E0B); // Warning Orange
  static const Color warningSoft = ThemeColor(0x1AF59E0B, 0x0DF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerSoft = ThemeColor(0x1AEF4444, 0x0DEF4444);
  static const Color info = Color(0xFF6366F1); // Indigo Community
  static const Color infoSoft = ThemeColor(0x1A6366F1, 0x0D6366F1);

  // ── Typography ──────────────────────────────────────────────────────
  static const Color textPrimary = ThemeColor(0xFFFFFFFF, 0xFF111827);
  static const Color textSecondary = ThemeColor(0xFF9CA3AF, 0xFF6B7280);
  static const Color textTertiary = ThemeColor(0xFF6B7280, 0xFF9CA3AF);
  static const Color textMuted = ThemeColor(0xFF6B7280, 0xFF9CA3AF);

  // ── Glass & Borders ─────────────────────────────────────────────────
  static const Color glassSurface = ThemeColor(0x14FFFFFF, 0x0D000000);
  static const Color glassHigh = ThemeColor(0x26FFFFFF, 0x1A000000);
  static const Color border = ThemeColor(0xFF222530, 0xFFE6E8F0);
  static const Color borderSubtle = ThemeColor(0x33222530, 0x1FE6E8F0);
  static const Color divider = ThemeColor(0xFF222530, 0xFFE6E8F0);

  // ── Overlay & Scrim ─────────────────────────────────────────────────
  static const Color overlay = ThemeColor(0xCC09090B, 0xCCF8F9FC);
  static const Color scrim = ThemeColor(0x99000000, 0x4D000000);

  // ── Shimmer / Skeleton Loading ──────────────────────────────────────
  static const Color shimmerBase = ThemeColor(0xFF161A22, 0xFFE6E8F0);
  static const Color shimmerHighlight = ThemeColor(0xFF222530, 0xFFF5F6FA);

  // ── Trust & Verification ────────────────────────────────────────────
  static const Color trustVerified = ThemeColor(0xFF10B981, 0xFF16A34A);
  static const Color trustPremium = Color(0xFFF59E0B);
  static const Color trustBadge = ThemeColor(0xFF6366F1, 0xFF2563EB);

  // ── Gradient Endpoints ──────────────────────────────────────────────
  static const Color gradientStart = ThemeColor(0xFF09090B, 0xFFF8F9FC);
  static const Color gradientEnd = ThemeColor(0xFF111318, 0xFFF5F6FA);
  static const Color heroGradientStart = ThemeColor(0xFF111318, 0xFFFFFFFF);
  static const Color heroGradientEnd = ThemeColor(0xFF09090B, 0xFFF8F9FC);

  static void updateTheme(bool dark) {
    isDark = dark;
  }
}
