import 'package:flutter/material.dart';

class SpottColors {
  // ── Backgrounds & Surfaces ──────────────────────────────────────────
  static const Color background = Color(0xFFF8F9FC);
  static const Color backgroundElevated = Color(0xFFFFFFFF); // Primary Surface
  static const Color surface1 = Color(0xFFFFFFFF); // Primary Surface
  static const Color surface2 = Color(0xFFF5F6FA); // Secondary Surface
  static const Color surface3 = Color(0xFFFFFFFF); // Card Surface
  static const Color cardSurface = Color(0xFFFFFFFF); // Card Surface
  static const Color surface4 = Color(0xFFE6E8F0); // Border Surface

  // ── Primary Palette & Actions ────────────────────────────────────────
  static const Color primary = Color(0xFFEE334A); // Primary Action
  static const Color primaryDark = Color(0xFFD9273D); // Primary Action Hover
  static const Color primarySoft = Color(0x1AEE334A); // 10% opacity

  // ── Accent ──────────────────────────────────────────────────────────
  static const Color accentPurple = Color(0xFF2563EB); // Route Accent Blue
  static const Color accentPurpleSoft = Color(0x1A2563EB); // 10%

  // ── Semantic Status ─────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color successSoft = Color(0x1A22C55E); // 10%
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSoft = Color(0x1AF59E0B); // 10%
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerSoft = Color(0x1AEF4444); // 10%
  static const Color info = Color(0xFF2563EB); // Route Accent
  static const Color infoSoft = Color(0x1A2563EB); // 10%

  // ── Typography ──────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF9CA3AF);

  // ── Glass & Borders ─────────────────────────────────────────────────
  static const Color glassSurface = Color(0xFFFFFFFF); // White cards
  static const Color glassHigh = Color(0x0D000000); // 5% black overlay for light depth
  static const Color border = Color(0xFFE6E8F0); // Border Color
  static const Color borderSubtle = Color(0x1F000000); // Subtle border
  static const Color divider = Color(0xFFE6E8F0); // Divider matches border

  // ── Overlay & Scrim ─────────────────────────────────────────────────
  static const Color overlay = Color(0xCCF8F9FC); // 80% background
  static const Color scrim = Color(0x4D000000); // 30% black

  // ── Shimmer / Skeleton Loading ──────────────────────────────────────
  static const Color shimmerBase = Color(0xFFE6E8F0);
  static const Color shimmerHighlight = Color(0xFFF5F6FA);

  // ── Trust & Verification ────────────────────────────────────────────
  static const Color trustVerified = Color(0xFF16A34A); // Verified Accent
  static const Color trustPremium = Color(0xFFF59E0B);
  static const Color trustBadge = Color(0xFF2563EB); // Route Accent

  // ── Gradient Endpoints ──────────────────────────────────────────────
  static const Color gradientStart = Color(0xFFF8F9FC);
  static const Color gradientEnd = Color(0xFFF5F6FA);
  static const Color heroGradientStart = Color(0xFFFFFFFF);
  static const Color heroGradientEnd = Color(0xFFF8F9FC);
}
