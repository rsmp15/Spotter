import 'package:flutter/material.dart';
import 'colors.dart';

class SpottShadows {
  // ── Glow variants (subtle colorful drops for premium visual interest) ──
  static final List<BoxShadow> glowPrimary = [
    BoxShadow(
      color: SpottColors.primary.withValues(alpha: 0.15),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> glowPurple = [
    BoxShadow(
      color: SpottColors.accentPurple.withValues(alpha: 0.15),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> glowSuccess = [
    BoxShadow(
      color: SpottColors.success.withValues(alpha: 0.1),
      blurRadius: 12,
      offset: const Offset(0, 2),
    ),
  ];

  static final List<BoxShadow> glowWarning = [
    BoxShadow(
      color: SpottColors.warning.withValues(alpha: 0.1),
      blurRadius: 12,
      offset: const Offset(0, 2),
    ),
  ];

  // ── Elevation levels (layered depth hierarchy for dark mode) ──────────
  /// Subtle lift — cards at rest
  static final List<BoxShadow> elevation1 = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.4),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  /// Medium lift — cards on hover/active state
  static final List<BoxShadow> elevation2 = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.5),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  /// High lift — floating panels, popovers
  static final List<BoxShadow> elevation3 = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.6),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  /// Maximum lift — modals, bottom sheets
  static final List<BoxShadow> elevation4 = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.7),
      blurRadius: 36,
      offset: const Offset(0, 16),
    ),
  ];

  // ── Legacy alias ────────────────────────────────────────────────────
  static final List<BoxShadow> elevationSm = elevation1;

  // ── Scene Glows (premium depth layers) ──────────────────────────────
  /// Red halo behind selected nav icon
  static final List<BoxShadow> navGlowRed = [
    BoxShadow(
      color: const Color(0x33E60023),
      blurRadius: 24,
      spreadRadius: 4,
    ),
  ];

  /// Diffuse ambient glow for hero search scene
  static final List<BoxShadow> heroGlow = [
    BoxShadow(
      color: SpottColors.primary.withValues(alpha: 0.08),
      blurRadius: 60,
      spreadRadius: 20,
    ),
  ];

  /// Nav bar floating shadow
  static final List<BoxShadow> navFloat = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.45),
      blurRadius: 40,
      offset: const Offset(0, -10),
    ),
  ];
}
