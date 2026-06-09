import 'package:flutter/material.dart';
import 'colors.dart';
import 'spacing.dart';
import 'radius.dart';

/// redBus-exact color palette and theme constants mapped to canonical Spott tokens
class RBColors {
  // ── Core Brand ──────────────────────────────────────────────────────
  static const Color primary = SpottColors.primary;  // redBus signature red
  static const Color primaryDark = SpottColors.primaryDark;
  static const Color primaryLight = SpottColors.primaryLight;
  static const Color primarySoft = SpottColors.primarySoft;

  // ── Backgrounds ─────────────────────────────────────────────────────
  static const Color background = SpottColors.background;
  static const Color surface = SpottColors.surface1;
  static const Color surfaceGrey = SpottColors.surface2;
  static const Color headerBg = SpottColors.primary;

  // ── Status Colors ────────────────────────────────────────────────────
  static const Color seatAvailable = SpottColors.success;
  static const Color seatUnavailable = SpottColors.textMuted;
  static const Color seatSelected = SpottColors.info;
  static const Color seatLadies = Color(0xFFE91E63);
  static const Color seatYellow = SpottColors.warning;

  // ── Text ─────────────────────────────────────────────────────────────
  static const Color textDark = SpottColors.textPrimary;
  static const Color textMedium = SpottColors.textSecondary;
  static const Color textLight = SpottColors.textTertiary;
  static const Color textWhite = Colors.white;

  // ── UI Elements ──────────────────────────────────────────────────────
  static const Color divider = SpottColors.divider;
  static const Color border = SpottColors.border;
  static const Color green = SpottColors.success;
  static const Color orange = SpottColors.warning;
  static const Color blue = SpottColors.info;
  static const Color purple = SpottColors.accentPurple;
  static const Color gold = SpottColors.trustPremium;
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
  static const double xs = SpottSpacing.xs;
  static const double sm = SpottSpacing.sm;
  static const double md = SpottSpacing.s12;
  static const double lg = SpottSpacing.md;
  static const double xl = SpottSpacing.s20;
  static const double xxl = SpottSpacing.lg;
  static const double pageH = SpottSpacing.pageHorizontal;
}

class RBRadius {
  static const double xs = SpottRadius.xs;
  static const double sm = SpottRadius.sm;
  static const double md = SpottRadius.lg; // Buttons / Inputs / Chips
  static const double lg = SpottRadius.xl; // Standard Cards
  static const double xl = SpottRadius.xxl; // Search Containers / Bottom Sheets
  static const double pill = SpottRadius.pill;
  static const double card = SpottRadius.card;
}
