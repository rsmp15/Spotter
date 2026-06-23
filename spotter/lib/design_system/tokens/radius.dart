import 'package:flutter/material.dart';

/// Canonical border radius tokens for the Spotter design system based on Uber Base.
class DSRadius {
  DSRadius._();

  static const double none = 0.0;
  static const double xs = 4.0; // Added for backward compatibility
  static const double sm = 8.0; // Added for backward compatibility
  static const double md = 8.0; // Form inputs
  static const double lg = 12.0; // Smaller secondary card chrome
  static const double xl = 16.0; // Canonical card radius
  static const double xxl = 24.0; // Extra large radius
  static const double pill = 999.0; // Signature interactive shape
  static const double pillTab = 36.0; // Tab toggle on hero
  static const double full = 9999.0; // Circular containers

  // Semantic component radius
  static const double button = pill;
  static const double card = xl;
  static const double input = md;
  static const double bottomSheet = xl;
  static const double dialog = xl;
  static const double avatar = full;

  static const BorderRadius borderSmall = BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderMedium = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius borderLarge = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius borderPill = BorderRadius.all(Radius.circular(pill));
}

