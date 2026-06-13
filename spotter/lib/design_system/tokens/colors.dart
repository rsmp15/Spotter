import 'package:flutter/material.dart';

/// Canonical semantic color tokens for the Spotter design system.
class DSColors {
  DSColors._();

  // Backgrounds & surfaces
  static const Color background = Color(0xFFF8F8F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color card = Color(0xFFFFFFFF);
  static const Color elevatedSurface = Color(0xFFFFFFFF);
  static const Color overlay = Color(0xCCF8F8F8);
  static const Color scrim = Color(0x4D000000);

  // Primary brand
  static const Color primary = Color(0xFFD84E55);
  static const Color primaryDark = Color(0xFFB73D45);
  static const Color primaryLight = Color(0xFFE57373);
  static const Color primarySoft = Color(0xFFFFEBEE);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Secondary / accent
  static const Color accent = Color(0xFF2563EB);
  static const Color accentSoft = Color(0xFFDBEAFE);

  // Semantic status
  static const Color success = Color(0xFF16A34A);
  static const Color successSoft = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFD97706);
  static const Color warningSoft = Color(0xFFFEF3C7);
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerSoft = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF2563EB);
  static const Color infoSoft = Color(0xFFDBEAFE);

  // Text and icons
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textTertiary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color iconPrimary = Color(0xFF111827);
  static const Color iconSecondary = Color(0xFF4B5563);

  // Borders and dividers
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderSubtle = Color(0xFFF3F4F6);
  static const Color divider = Color(0xFFE5E7EB);

  // Glass and low-contrast layers
  static const Color glass = Color(0xFFFFFFFF);
  static const Color glassHigh = Color(0xFFFFFFFF);
  static const Color glassBorder = Color(0xFFE5E7EB);

  // Skeleton/shimmer
  static const Color shimmerBase = Color(0xFFE5E7EB);
  static const Color shimmerHighlight = Color(0xFFF3F4F6);

  // Legacy aliases for migration
  static const Color backgroundElevated = elevatedSurface;
  static const Color cardBackground = card;
  static const Color inputBackground = surface;
}

/// A complete semantic palette for a brightness mode.
///
/// Keep component code pointed at these semantic names rather than primitive
/// brand values so the app can move between light, dark, and future brand
/// refreshes without another screen-by-screen migration.
class DSColorPalette {
  const DSColorPalette({
    required this.brightness,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.card,
    required this.elevatedSurface,
    required this.overlay,
    required this.scrim,
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.primarySoft,
    required this.onPrimary,
    required this.accent,
    required this.accentSoft,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.danger,
    required this.dangerSoft,
    required this.info,
    required this.infoSoft,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textMuted,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.border,
    required this.borderSubtle,
    required this.divider,
    required this.glass,
    required this.glassHigh,
    required this.glassBorder,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  final Brightness brightness;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color card;
  final Color elevatedSurface;
  final Color overlay;
  final Color scrim;
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color primarySoft;
  final Color onPrimary;
  final Color accent;
  final Color accentSoft;
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color danger;
  final Color dangerSoft;
  final Color info;
  final Color infoSoft;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textMuted;
  final Color iconPrimary;
  final Color iconSecondary;
  final Color border;
  final Color borderSubtle;
  final Color divider;
  final Color glass;
  final Color glassHigh;
  final Color glassBorder;
  final Color shimmerBase;
  final Color shimmerHighlight;

  bool get isDark => brightness == Brightness.dark;

  ColorScheme get colorScheme {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      secondary: accent,
      onSecondary: onPrimary,
      error: danger,
      onError: onPrimary,
      surface: surface,
      onSurface: textPrimary,
    );
  }

  Map<String, String> toTokenJson() {
    return {
      'background': _hex(background),
      'surface': _hex(surface),
      'surfaceVariant': _hex(surfaceVariant),
      'card': _hex(card),
      'elevatedSurface': _hex(elevatedSurface),
      'overlay': _hex(overlay),
      'scrim': _hex(scrim),
      'primary': _hex(primary),
      'primaryDark': _hex(primaryDark),
      'primaryLight': _hex(primaryLight),
      'primarySoft': _hex(primarySoft),
      'onPrimary': _hex(onPrimary),
      'accent': _hex(accent),
      'accentSoft': _hex(accentSoft),
      'success': _hex(success),
      'successSoft': _hex(successSoft),
      'warning': _hex(warning),
      'warningSoft': _hex(warningSoft),
      'danger': _hex(danger),
      'dangerSoft': _hex(dangerSoft),
      'info': _hex(info),
      'infoSoft': _hex(infoSoft),
      'textPrimary': _hex(textPrimary),
      'textSecondary': _hex(textSecondary),
      'textTertiary': _hex(textTertiary),
      'textMuted': _hex(textMuted),
      'iconPrimary': _hex(iconPrimary),
      'iconSecondary': _hex(iconSecondary),
      'border': _hex(border),
      'borderSubtle': _hex(borderSubtle),
      'divider': _hex(divider),
      'glass': _hex(glass),
      'glassHigh': _hex(glassHigh),
      'glassBorder': _hex(glassBorder),
      'shimmerBase': _hex(shimmerBase),
      'shimmerHighlight': _hex(shimmerHighlight),
    };
  }

  static String _hex(Color color) {
    final value = color.toARGB32();
    return '#${value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }
}

class DSPalettes {
  DSPalettes._();

  static const DSColorPalette light = DSColorPalette(
    brightness: Brightness.light,
    background: DSColors.background,
    surface: DSColors.surface,
    surfaceVariant: DSColors.surfaceVariant,
    card: DSColors.card,
    elevatedSurface: DSColors.elevatedSurface,
    overlay: DSColors.overlay,
    scrim: DSColors.scrim,
    primary: DSColors.primary,
    primaryDark: DSColors.primaryDark,
    primaryLight: DSColors.primaryLight,
    primarySoft: DSColors.primarySoft,
    onPrimary: DSColors.onPrimary,
    accent: DSColors.accent,
    accentSoft: DSColors.accentSoft,
    success: DSColors.success,
    successSoft: DSColors.successSoft,
    warning: DSColors.warning,
    warningSoft: DSColors.warningSoft,
    danger: DSColors.danger,
    dangerSoft: DSColors.dangerSoft,
    info: DSColors.info,
    infoSoft: DSColors.infoSoft,
    textPrimary: DSColors.textPrimary,
    textSecondary: DSColors.textSecondary,
    textTertiary: DSColors.textTertiary,
    textMuted: DSColors.textMuted,
    iconPrimary: DSColors.iconPrimary,
    iconSecondary: DSColors.iconSecondary,
    border: DSColors.border,
    borderSubtle: DSColors.borderSubtle,
    divider: DSColors.divider,
    glass: DSColors.glass,
    glassHigh: DSColors.glassHigh,
    glassBorder: DSColors.glassBorder,
    shimmerBase: DSColors.shimmerBase,
    shimmerHighlight: DSColors.shimmerHighlight,
  );

  static const DSColorPalette dark = DSColorPalette(
    brightness: Brightness.dark,
    background: Color(0xFF0B0D10),
    surface: Color(0xFF111418),
    surfaceVariant: Color(0xFF191D23),
    card: Color(0xFF15191F),
    elevatedSurface: Color(0xFF1B2028),
    overlay: Color(0xCC0B0D10),
    scrim: Color(0x99000000),
    primary: Color(0xFFFF6B72),
    primaryDark: Color(0xFFD84E55),
    primaryLight: Color(0xFFFFA0A5),
    primarySoft: Color(0xFF3A171B),
    onPrimary: Color(0xFFFFFFFF),
    accent: Color(0xFF78A6FF),
    accentSoft: Color(0xFF102544),
    success: Color(0xFF4ADE80),
    successSoft: Color(0xFF0F2A19),
    warning: Color(0xFFFBBF24),
    warningSoft: Color(0xFF30220A),
    danger: Color(0xFFF87171),
    dangerSoft: Color(0xFF321515),
    info: Color(0xFF60A5FA),
    infoSoft: Color(0xFF102544),
    textPrimary: Color(0xFFF9FAFB),
    textSecondary: Color(0xFFD1D5DB),
    textTertiary: Color(0xFF9CA3AF),
    textMuted: Color(0xFF6B7280),
    iconPrimary: Color(0xFFF9FAFB),
    iconSecondary: Color(0xFFD1D5DB),
    border: Color(0xFF2B313A),
    borderSubtle: Color(0xFF20252D),
    divider: Color(0xFF2B313A),
    glass: Color(0xCC15191F),
    glassHigh: Color(0xE61B2028),
    glassBorder: Color(0xFF303743),
    shimmerBase: Color(0xFF20252D),
    shimmerHighlight: Color(0xFF2B313A),
  );
}
