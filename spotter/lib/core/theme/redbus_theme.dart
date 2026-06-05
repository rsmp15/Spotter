import 'package:flutter/material.dart';

/// redBus-exact color palette and theme constants
class RBColors {
  // ── Core Brand ──────────────────────────────────────────────────────
  static const Color primary = Color(0xFFD84E55);  // redBus signature red
  static const Color primaryDark = Color(0xFFB73D45);
  static const Color primaryLight = Color(0xFFE57373);
  static const Color primarySoft = Color(0xFFFFEBEE);

  // ── Backgrounds ─────────────────────────────────────────────────────
  static const Color background = Color(0xFFF8F8F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceGrey = Color(0xFFF8F8F8);
  static const Color headerBg = Color(0xFFD84E55);

  // ── Status Colors ────────────────────────────────────────────────────
  static const Color seatAvailable = Color(0xFF22C55E);
  static const Color seatUnavailable = Color(0xFF9E9E9E);
  static const Color seatSelected = Color(0xFF2196F3);
  static const Color seatLadies = Color(0xFFE91E63);
  static const Color seatYellow = Color(0xFFFFC107);

  // ── Text ─────────────────────────────────────────────────────────────
  static const Color textDark = Color(0xFF1D1D1D);
  static const Color textMedium = Color(0xFF666666);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color textWhite = Color(0xFFFFFFFF);

  // ── UI Elements ──────────────────────────────────────────────────────
  static const Color divider = Color(0xFFEAEAEA);
  static const Color border = Color(0xFFEAEAEA);
  static const Color green = Color(0xFF4CAF50);
  static const Color orange = Color(0xFFFF9800);
  static const Color blue = Color(0xFF2196F3);
  static const Color purple = Color(0xFF9C27B0);
  static const Color gold = Color(0xFFFFC107);
}

class RBTextStyles {
  static const String font = 'Inter';

  static const TextStyle appBarTitle = TextStyle(
    fontFamily: font,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: RBColors.textWhite,
    letterSpacing: 0.3,
  );

  static const TextStyle routeCity = TextStyle(
    fontFamily: font,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: RBColors.textDark,
    letterSpacing: -0.3,
  );

  static const TextStyle routeSubtitle = TextStyle(
    fontFamily: font,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: RBColors.textLight,
  );

  static const TextStyle sectionHeader = TextStyle(
    fontFamily: font,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: RBColors.textDark,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: font,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: RBColors.textDark,
    letterSpacing: -0.2,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontFamily: font,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: RBColors.textMedium,
  );

  static const TextStyle price = TextStyle(
    fontFamily: font,
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: RBColors.primary,
    letterSpacing: -0.3,
  );

  static const TextStyle priceSmall = TextStyle(
    fontFamily: font,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: RBColors.primary,
  );

  static const TextStyle badge = TextStyle(
    fontFamily: font,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: RBColors.textWhite,
  );

  static const TextStyle amenity = TextStyle(
    fontFamily: font,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: RBColors.textMedium,
  );

  static const TextStyle buttonLabel = TextStyle(
    fontFamily: font,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: RBColors.textWhite,
    letterSpacing: 0.3,
  );

  static const TextStyle filterLabel = TextStyle(
    fontFamily: font,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: RBColors.textDark,
  );

  static const TextStyle bodyText = TextStyle(
    fontFamily: font,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: RBColors.textMedium,
  );
}

class RBSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double pageH = 16.0;
}

class RBRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0; // Buttons / Inputs / Chips
  static const double lg = 20.0; // Standard Cards
  static const double xl = 24.0; // Search Containers / Bottom Sheets
  static const double pill = 9999.0;
  static const double card = 20.0; // Standard Cards
}
