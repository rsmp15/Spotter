import 'package:flutter/animation.dart';

/// Motion tokens for the Spotter design system.
class DSMotion {
  DSMotion._();

  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration extraSlow = Duration(milliseconds: 600);

  static const Curve ease = Curves.easeInOut;
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve spring = Curves.easeOutBack;
}

