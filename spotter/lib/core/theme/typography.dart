import 'package:flutter/material.dart';
import 'colors.dart';

class SpottTextStyles {
  static const String _fontFamily = 'Inter';

  // ── Display ─────────────────────────────────────────────────────────
  /// Large hero text
  static const TextStyle displayXL = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.w600, // SemiBold
    color: SpottColors.textPrimary,
    letterSpacing: -0.6,
    height: 1.1,
  );

  /// Hero text — welcome headlines
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w600, // SemiBold
    color: SpottColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.15,
  );

  /// Screen headlines — page headings
  static const TextStyle display = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600, // SemiBold
    color: SpottColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.2,
  );

  // ── Headlines & Titles ──────────────────────────────────────────────
  /// Section titles
  static const TextStyle headline = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600, // SemiBold
    color: SpottColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.25,
  );

  /// Card titles
  static const TextStyle title = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500, // Medium
    color: SpottColors.textPrimary,
    letterSpacing: -0.1,
    height: 1.3,
  );

  /// Small titles or subheadings
  static const TextStyle titleSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
    color: SpottColors.textPrimary,
    letterSpacing: -0.1,
    height: 1.35,
  );

  // ── Body ────────────────────────────────────────────────────────────
  /// Primary body text, descriptions, inputs
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    color: SpottColors.textSecondary,
    height: 1.45,
  );

  /// Standard body text
  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    color: SpottColors.textSecondary,
    height: 1.4,
  );

  /// Small body text
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    color: SpottColors.textSecondary,
    height: 1.4,
  );

  // ── Label ───────────────────────────────────────────────────────────
  /// Prominent button text
  static const TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold
    color: SpottColors.textPrimary,
    letterSpacing: 0.1,
    height: 1.3,
  );

  /// Button labels, inline action text
  static const TextStyle label = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    color: SpottColors.textPrimary,
    letterSpacing: 0.1,
    height: 1.3,
  );

  // ── Small ───────────────────────────────────────────────────────────
  /// Timestamps, metadata, helper text, badges
  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500, // Medium
    color: SpottColors.textTertiary,
    height: 1.4,
  );

  /// Category labels, section markers
  static const TextStyle overline = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500, // Medium
    color: SpottColors.textTertiary,
    letterSpacing: 1.2,
    height: 1.4,
  );

  // ── Monospace ───────────────────────────────────────────────────────
  /// OTP codes, verification codes, IDs
  static const TextStyle mono = TextStyle(
    fontFamily: 'RobotoMono',
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    color: SpottColors.textPrimary,
    letterSpacing: 2.0,
    height: 1.4,
  );

  // ── Legacy aliases (backward compat) ────────────────────────────────
  static const TextStyle screenTitle = display;
  static const TextStyle sectionTitle = headline;
}

