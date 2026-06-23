import 'package:flutter/material.dart';

/// Canonical elevation shadows for the Spotter design system based on Uber Base.
class DSShadows {
  DSShadows._();

  // Level 0 — Flat (No shadow)
  static const List<BoxShadow> level0 = [];

  // Level 1 — Subtle Drop: rgba(0, 0, 0, 0.12) 0px 4px 16px 0px
  static const List<BoxShadow> level1 = [
    BoxShadow(
      color: Color(0x1F000000), // 0.12 * 255 = 30.6 -> 0x1F
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  // Level 2 — Card Drop: rgba(0, 0, 0, 0.16) 0px 4px 16px 0px
  static const List<BoxShadow> level2 = [
    BoxShadow(
      color: Color(0x29000000), // 0.16 * 255 = 40.8 -> 0x29
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  // Level 3 — Pill Float: rgba(0, 0, 0, 0.16) 0px 2px 8px 0px
  static const List<BoxShadow> level3 = [
    BoxShadow(
      color: Color(0x29000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  // Mappings for backward compatibility
  static const List<BoxShadow> elevation1 = level1;
  static const List<BoxShadow> elevation2 = level2;
  static const List<BoxShadow> elevation3 = level3;
  static const List<BoxShadow> elevation4 = level2;

  // Uber has no chromatic glows
  static const List<BoxShadow> glowPrimary = level0;
  static const List<BoxShadow> glowAccent = level0;
}

