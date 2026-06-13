import 'package:flutter/material.dart';

/// Canonical spacing tokens for the Spotter design system.
class DSSpacing {
  DSSpacing._();

  // Base scale
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Semantic spacing
  static const double page = 20.0;
  static const double pageInset = 16.0;
  static const double section = 24.0;
  static const double sectionDense = 16.0;
  static const double card = 16.0;
  static const double formField = 16.0;
  static const double control = 12.0;
  static const double touch = 20.0;

  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: pageInset,
    vertical: 16.0,
  );
  static const EdgeInsets cardPadding = EdgeInsets.all(card);
}
