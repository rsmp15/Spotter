import 'package:flutter/material.dart';
import 'colors.dart';

class SpottGradients {
  // ── Button gradients ────────────────────────────────────────────────
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [SpottColors.primary, SpottColors.primaryDark],
  );

  static const LinearGradient accent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [SpottColors.accentPurple, Color(0xFF1D4ED8)], // Rich route blue
  );

  // ── Surface gradients (subtle depth on cards - now flattened/lightened) ──
  static const LinearGradient surface = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFFFFFFF),
    ],
  );

  static const LinearGradient surfaceElevated = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF5F6FA),
    ],
  );

  // ── Hero / background gradients ─────────────────────────────────────
  static const LinearGradient hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [SpottColors.background, Color(0xFFFFFFFF)],
  );

  static const RadialGradient heroGlow = RadialGradient(
    center: Alignment.center,
    radius: 0.8,
    colors: [
      Colors.transparent,
      Colors.transparent,
    ],
  );

  // ── Trust gradient (verification badges) ────────────────────────────
  static const LinearGradient trust = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [SpottColors.success, Color(0xFF16A34A)],
  );

  static const LinearGradient premium = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB020), Color(0xFFFF8C00)],
  );

  // ── Shimmer gradient (skeleton loading) ─────────────────────────────
  static const LinearGradient shimmer = LinearGradient(
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    colors: [
      SpottColors.shimmerBase,
      SpottColors.shimmerHighlight,
      SpottColors.shimmerBase,
    ],
    stops: [0.0, 0.5, 1.0],
  );
}
