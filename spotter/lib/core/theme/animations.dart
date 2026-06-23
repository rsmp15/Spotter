import 'package:flutter/material.dart';

// ── Durations ─────────────────────────────────────────────────────────
class SpottAnimations {
  /// Micro feedback — button press, icon toggle
  static const Duration instant = Duration(milliseconds: 100);
  /// Element transitions — chip select, tab switch
  static const Duration fast = Duration(milliseconds: 150);
  /// Page transitions — screen enter/exit
  static const Duration medium = Duration(milliseconds: 200);
  /// Reveal animations — staggered lists, hero sections
  static const Duration slow = Duration(milliseconds: 250);
  /// Delay between staggered list items
  static const Duration stagger = Duration(milliseconds: 30);
}

// ── Curves ────────────────────────────────────────────────────────────
class SpottCurves {
  /// General-purpose smooth transition
  static const Curve standard = Curves.easeInOut;
  /// Enter/exit with emphasis (Apple-inspired)
  static const Curve emphasized = Curves.fastOutSlowIn;
  /// Decelerate into final position (natural settling)
  static const Curve decelerate = Curves.decelerate;
  /// Standard smooth ease out curve (bouncy spring removed)
  static const Curve spring = Curves.easeOutCubic;
  /// Standard smooth ease out curve (bouncy overshoot removed)
  static const Curve overshoot = Curves.easeOutCubic;
}

// ── Page Transition Builders ──────────────────────────────────────────
class SpottPageTransitions {
  /// Fade + slight slide up (default screen transition)
  static Widget fadeSlideUp(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: SpottCurves.emphasized,
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: SpottCurves.emphasized,
        )),
        child: child,
      ),
    );
  }

  /// Scale + fade for modals and overlays
  static Widget scaleFade(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: SpottCurves.emphasized,
      ),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.95, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: SpottCurves.emphasized,
          ),
        ),
        child: child,
      ),
    );
  }
}

