import 'package:flutter/material.dart';
import '../../design_system/tokens/shadows.dart';

class SpottShadows {
  // ── Glow variants (subtle colorful drops for premium visual interest) ──
  static const List<BoxShadow> glowPrimary = [
    BoxShadow(
      color: Color(0x08D84E55),
      blurRadius: 10,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> glowPurple = [
    BoxShadow(
      color: Color(0x08B73D45),
      blurRadius: 10,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> glowSuccess = [
    BoxShadow(
      color: Color(0x0516A34A),
      blurRadius: 8,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> glowWarning = [
    BoxShadow(
      color: Color(0x05D97706),
      blurRadius: 8,
      offset: Offset(0, 1),
    ),
  ];

  // ── Elevation levels (layered depth hierarchy for clean light mode) ──
  /// Subtle lift — cards at rest
  static const List<BoxShadow> elevation1 = DSShadows.elevation1;

  /// Medium lift — cards on hover/active state
  static const List<BoxShadow> elevation2 = DSShadows.elevation2;

  /// High lift — floating panels, popovers
  static const List<BoxShadow> elevation3 = DSShadows.elevation3;

  /// Maximum lift — modals, bottom sheets
  static const List<BoxShadow> elevation4 = DSShadows.elevation4;

  // ── Legacy alias ────────────────────────────────────────────────────
  static const List<BoxShadow> elevationSm = elevation1;

  // ── Scene Glows (premium depth layers) ──────────────────────────────
  /// Red halo behind selected nav icon
  static const List<BoxShadow> navGlowRed = [
    BoxShadow(
      color: Color(0x0DE60023),
      blurRadius: 12,
      spreadRadius: 2,
    ),
  ];

  /// Diffuse ambient glow for hero search scene
  static const List<BoxShadow> heroGlow = [];

  /// Nav bar floating shadow
  static const List<BoxShadow> navFloat = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 16,
      offset: Offset(0, -4),
    ),
  ];

  /// Airbnb-style subtle card shadow
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  /// Bottom bar shadow
  static const List<BoxShadow> bottomBarShadow = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 16,
      offset: Offset(0, -2),
    ),
  ];

  /// Sticky header shadow
  static const List<BoxShadow> stickyHeaderShadow = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];
}
