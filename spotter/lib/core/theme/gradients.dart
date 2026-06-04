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

  // ── Bento Card Gradients (each card has its own personality) ─────────
  /// Find Ride — deep red scene
  static const LinearGradient bentoRide = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE60023), Color(0xFF7F0015)],
  );

  /// Offer Trip — deep green scene
  static const LinearGradient bentoTrip = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF065F46)],
  );

  /// Send Parcel — deep amber scene
  static const LinearGradient bentoParcel = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFF92400E)],
  );

  /// Nearby — deep indigo scene
  static const LinearGradient bentoNearby = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF312E81)],
  );

  // ── Banner Gradients ────────────────────────────────────────────────
  /// Parcel campaign banner — amber warmth
  static const LinearGradient parcelBanner = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFB45309)],
  );

  /// Become Traveler banner — indigo emotion
  static const LinearGradient travelerBanner = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF4338CA)],
  );

  // ── Image Overlay Gradient ──────────────────────────────────────────
  /// Dark fade overlay for featured trip card images
  static const LinearGradient imageOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color(0xDD111318),
    ],
  );
}
