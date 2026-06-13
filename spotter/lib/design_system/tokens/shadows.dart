import 'package:flutter/material.dart';

/// Canonical elevation shadows for the Spotter design system.
class DSShadows {
  DSShadows._();

  static const List<BoxShadow> elevation1 = [
    BoxShadow(
      color: Color(0x0C000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> elevation2 = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> elevation3 = [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> elevation4 = [
    BoxShadow(
      color: Color(0x15000000),
      blurRadius: 24,
      offset: Offset(0, 10),
    ),
  ];

  static const List<BoxShadow> glowPrimary = [
    BoxShadow(
      color: Color(0x0AD84E55),
      blurRadius: 10,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> glowAccent = [
    BoxShadow(
      color: Color(0x0A2563EB),
      blurRadius: 10,
      offset: Offset(0, 2),
    ),
  ];
}
