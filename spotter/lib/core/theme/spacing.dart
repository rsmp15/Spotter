import '../../design_system/tokens/spacing.dart';

class SpottSpacing {
  // ── Base 8pt scale scale ──────────────────────────────────────────────
  static const double s4 = DSSpacing.xs;
  static const double s8 = DSSpacing.sm;
  static const double s12 = DSSpacing.md;
  static const double s16 = DSSpacing.md;
  static const double s20 = DSSpacing.page;
  static const double s24 = DSSpacing.lg;
  static const double s32 = DSSpacing.xl;
  static const double s40 = 40.0;
  static const double s48 = DSSpacing.xxl;

  // ── Legacy alias scale (updated to fit 8pt grid) ──────────────────────
  static const double xs = DSSpacing.xs;
  static const double sm = DSSpacing.sm;
  static const double md = DSSpacing.md;
  static const double lg = DSSpacing.lg;
  static const double xl = DSSpacing.xl;
  static const double xxl = DSSpacing.xxl;
  static const double xxxl = 64.0;

  // ── Semantic spacing ────────────────────────────────────────────────
  /// Premium card inner padding
  static const double cardInner = DSSpacing.card;
  /// Between major content sections (breathing room)
  static const double section = DSSpacing.section;
  /// Top padding for screen content below app bar
  static const double pageTop = DSSpacing.pageInset;
  /// Bottom padding to clear floating navigation bar
  static const double pageBottom = 120.0;
  /// Horizontal page margins
  static const double pageHorizontal = 12.0;
}
