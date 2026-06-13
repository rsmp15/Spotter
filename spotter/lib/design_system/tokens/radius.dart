import 'package:flutter/material.dart';

/// Canonical border radius tokens for the Spotter design system.
class DSRadius {
  DSRadius._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double pill = 9999.0;

  static const double button = 16.0;
  static const double card = 20.0;
  static const double input = 16.0;
  static const double bottomSheet = 24.0;
  static const double dialog = 28.0;
  static const double avatar = 9999.0;

  static const BorderRadius borderSmall = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius borderMedium = BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderLarge = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius borderPill = BorderRadius.all(Radius.circular(pill));
}
