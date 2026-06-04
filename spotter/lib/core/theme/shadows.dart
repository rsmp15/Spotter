import 'package:flutter/material.dart';
import 'colors.dart';

class SpottShadows {
  // ── Glow variants (now flattened to subtle dark shadows for Light Theme) ──
  static final List<BoxShadow> glowPrimary = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> glowPurple = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> glowSuccess = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static final List<BoxShadow> glowWarning = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  // ── Elevation levels (layered depth hierarchy) ──────────────────────
  /// Subtle lift — cards at rest
  static final List<BoxShadow> elevation1 = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  /// Medium lift — cards on hover/active state
  static final List<BoxShadow> elevation2 = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  /// High lift — floating panels, popovers
  static final List<BoxShadow> elevation3 = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  /// Maximum lift — modals, bottom sheets
  static final List<BoxShadow> elevation4 = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 32,
      offset: const Offset(0, 16),
    ),
  ];

  // ── Legacy alias ────────────────────────────────────────────────────
  static final List<BoxShadow> elevationSm = elevation1;
}
