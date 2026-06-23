import 'package:flutter/material.dart';
import '../../design_system/tokens/colors.dart';

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
  static const Color background = DSColors.background;
  static const Color backgroundElevated = DSColors.elevatedSurface;
  static const Color surface1 = DSColors.surface;
  static const Color surface2 = DSColors.surfaceVariant; // Slightly off-white for depth / chips
  static const Color surface3 = DSColors.surface;
  static const Color cardSurface = DSColors.card;
  static const Color surface4 = DSColors.surface;
  static const Color surfaceContainer = DSColors.surface;

  // ── Primary Palette & Actions ────────────────────────────────────────
  static const Color primary = DSColors.primary; // redBus Red
  static const Color primaryDark = DSColors.primaryDark; // redBus Dark Red
  static const Color primaryLight = DSColors.primaryLight;
  static const Color primarySoft = DSColors.primarySoft;

  // ── Interactive State Tokens ──────────────────────────────────────────
  static const Color primaryPressed = Color(0xFF9E2A30); // Darker red on press
  static const Color primaryHover = Color(0xFFE55D63); // Lighter red on hover
  static const Color disabled = DSColors.border;
  static const Color disabledText = DSColors.textMuted;
  static const Color overlayHover = Color(0x0A000000);
  static const Color overlayPressed = Color(0x1A000000);

  // ── Accent (Marketplace & Community Accent) ──────────────────────────
  static const Color accentPurple = DSColors.primaryDark; // redBus Secondary Dark Red
  static const Color accentPurpleSoft = DSColors.primarySoft;
  static const Color accentSecondaryContainer = DSColors.primary;

  // ── Semantic Status & Trust (WCAG Contrast Safe) ──────────────────────────
  static const Color success = DSColors.success; // Emerald Green
  static const Color successSoft = DSColors.successSoft;
  static const Color warning = DSColors.warning; // Amber
  static const Color warningSoft = DSColors.warningSoft;
  static const Color danger = DSColors.danger; // Red
  static const Color dangerSoft = DSColors.dangerSoft;
  static const Color info = DSColors.info; // Blue
  static const Color infoSoft = DSColors.infoSoft;

  // ── Typography (Contrast ratios >= 4.5:1) ──────────────────────────────────────────────────────
  static const Color textPrimary = DSColors.textPrimary; // Dark gray (almost black)
  static const Color textSecondary = DSColors.textSecondary; // Medium gray
  static const Color textTertiary = DSColors.textTertiary; // Light gray
  static const Color textMuted = DSColors.textMuted; // Muted gray

  // ── Icons ───────────────────────────────────────────────────────────
  static const Color iconPrimary = DSColors.iconPrimary;
  static const Color iconSecondary = DSColors.iconSecondary;

  // ── Inputs & Cards ──────────────────────────────────────────────────
  static const Color inputBackground = DSColors.surface;
  static const Color cardBackground = DSColors.card;

  // ── Offer / Banner Accent Colors ─────────────────────────────────────
  static const Color offerRed = Color(0xFFE53935);
  static const Color offerBlue = Color(0xFF1976D2);
  static const Color offerGreen = Color(0xFF43A047);
  static const Color offerPurple = Color(0xFF8E24AA);

  // ── Glass & Borders ─────────────────────────────────────────────────
  static const Color glassSurface = DSColors.glass;
  static const Color glassHigh = DSColors.glassHigh;
  static const Color border = DSColors.border;
  static const Color borderSubtle = DSColors.borderSubtle;
  static const Color divider = DSColors.divider;

  // ── Overlay & Scrim ─────────────────────────────────────────────────
  static const Color overlay = DSColors.overlay;
  static const Color scrim = DSColors.scrim;

  // ── Shimmer / Skeleton Loading ──────────────────────────────────────
  static const Color shimmerBase = DSColors.shimmerBase;
  static const Color shimmerHighlight = DSColors.shimmerHighlight;

  // ── Trust & Verification ────────────────────────────────────────────
  static const Color trustVerified = DSColors.success;
  static const Color trustPremium = DSColors.warning;
  static const Color trustBadge = DSColors.info;

  // ── Gradient Endpoints ──────────────────────────────────────────────
  static const Color gradientStart = DSColors.surface;
  static const Color gradientEnd = DSColors.background;
  static const Color heroGradientStart = DSColors.surface;
  static const Color heroGradientEnd = DSColors.background;

  static void updateTheme(bool dark) {
    isDark = dark;
  }
}

