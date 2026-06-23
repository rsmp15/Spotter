import 'package:flutter/material.dart';

/// Canonical spacing tokens for the Spotter design system based on Uber Base.
class DSSpacing {
  DSSpacing._();

  // Base scale (multiples of 4px, plus 6px sub-multiple)
  static const double xxs = 4.0;
  static const double xs = 6.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  // Semantic mappings
  static const double page = 32.0; // 32px horizontal gutters
  static const double pageInset = 16.0; // Mobile gutter
  static const double section = 32.0; // Section padding
  static const double sectionDense = 16.0;
  static const double card = 24.0; // Card interior padding
  static const double formField = 16.0; // Ride-request form interior
  static const double control = 12.0; // Button/chip padding
  static const double touch = 20.0;

  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: pageInset,
    vertical: 16.0,
  );
  static const EdgeInsets cardPadding = EdgeInsets.all(card);
  static const EdgeInsets formPadding = EdgeInsets.all(formField);
}

