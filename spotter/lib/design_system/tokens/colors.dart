import 'package:flutter/material.dart';

/// Canonical semantic color tokens for the Spotter design system.
class DSColors {
  DSColors._();

  // Backgrounds & surfaces (Canvas)
  static const Color background = Color(0xFFFFFFFF); // Canvas
  static const Color surface = Color(0xFFFFFFFF); // Canvas
  static const Color surfaceVariant = Color(0xFFEFEFEF); // Canvas Soft
  static const Color card = Color(0xFFFFFFFF); // Canvas
  static const Color elevatedSurface = Color(0xFFFFFFFF); // Canvas
  static const Color overlay = Color(0xCCFFFFFF);
  static const Color scrim = Color(0x4D000000);

  // Brand & Accent
  static const Color primary = Color(0xFF000000); // Ink Black
  static const Color primaryDark = Color(0xFF000000); // Ink Black
  static const Color primaryLight = Color(0xFF282828); // Black Elevated
  static const Color primarySoft = Color(0xFFEFEFEF); // Canvas Soft
  static const Color onPrimary = Color(0xFFFFFFFF); // On Dark

  // Accent mapping
  static const Color accent = Color(0xFF000000); // Ink Black
  static const Color accentSoft = Color(0xFFEFEFEF); // Canvas Soft
  static const Color surfacePressed = Color(0xFFE2E2E2); // Surface Pressed
  static const Color blackElevated = Color(0xFF282828); // Black Elevated
  static const Color canvasSofter = Color(0xFFF3F3F3); // Canvas Softer

  // Semantic status
  static const Color success = Color(0xFF05A357);
  static const Color successSoft = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFD97706);
  static const Color warningSoft = Color(0xFFFEF3C7);
  static const Color danger = Color(0xFFE11900);
  static const Color dangerSoft = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF276EF1);
  static const Color infoSoft = Color(0xFFEAF2FF);

  // Text and icons
  static const Color textPrimary = Color(0xFF000000); // Ink
  static const Color textSecondary = Color(0xFF5E5E5E); // Body
  static const Color textTertiary = Color(0xFF4B4B4B); // Hairline Mid
  static const Color textMuted = Color(0xFFAFAFAF); // Mute
  static const Color iconPrimary = Color(0xFF000000); // Ink
  static const Color iconSecondary = Color(0xFF5E5E5E); // Body

  // Borders and dividers
  static const Color border = Color(0xFFE2E2E2); // Surface Pressed
  static const Color borderSubtle = Color(0xFFF3F3F3); // Canvas Softer
  static const Color divider = Color(0xFFE2E2E2); // Surface Pressed

  // Glass and low-contrast layers
  static const Color glass = Color(0xFFFFFFFF);
  static const Color glassHigh = Color(0xFFFFFFFF);
  static const Color glassBorder = Color(0xFFE2E2E2);

  // Skeleton/shimmer
  static const Color shimmerBase = Color(0xFFEFEFEF); // Canvas Soft
  static const Color shimmerHighlight = Color(0xFFF3F3F3); // Canvas Softer

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
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFE4E7E8),
    card: Color(0xFFFFFFFF),
    elevatedSurface: Color(0xFFFFFFFF),
    overlay: Color(0xCCF8F9FA),
    scrim: Color(0x4D000000),
    primary: Color(0xFF14262A),
    primaryDark: Color(0xFF0F1B1E),
    primaryLight: Color(0xFF244147),
    primarySoft: Color(0xFFD2E5EA),
    onPrimary: Color(0xFFFFFFFF),
    accent: Color(0xFF14262A),
    accentSoft: Color(0xFFD2E5EA),
    success: DSColors.success,
    successSoft: DSColors.successSoft,
    warning: DSColors.warning,
    warningSoft: DSColors.warningSoft,
    danger: DSColors.danger,
    dangerSoft: DSColors.dangerSoft,
    info: DSColors.info,
    infoSoft: DSColors.infoSoft,
    textPrimary: Color(0xFF14262A),
    textSecondary: Color(0xFF5E5E5E),
    textTertiary: Color(0xFF7E8C8E),
    textMuted: Color(0xFFAFAFAF),
    iconPrimary: Color(0xFF14262A),
    iconSecondary: Color(0xFF5E5E5E),
    border: Color(0xFFE5D9DB),
    borderSubtle: Color(0xFFF3EDEE),
    divider: Color(0xFFE5D9DB),
    glass: Color(0xCCFFFFFF),
    glassHigh: Color(0xE6FFFFFF),
    glassBorder: Color(0xFFE5D9DB),
    shimmerBase: Color(0xFFEDE2E6),
    shimmerHighlight: Color(0xFFF8F9FA),
  );

  static const DSColorPalette dark = DSColorPalette(
    brightness: Brightness.dark,
    background: Color(0xFF0F1114),      // Rich Obsidian background
    surface: Color(0xFF1E352F),         // Deep Forest surface
    surfaceVariant: Color(0xFF25413A),  // Lighter forest green variant
    card: Color(0xFF1E352F),
    elevatedSurface: Color(0xFF2C4C44),  // Elevated green surface
    overlay: Color(0xCC0F1114),
    scrim: Color(0x99000000),
    primary: Color(0xFF397B70),          // Muted Emerald/Teal brand color
    primaryDark: Color(0xFF2D6259),
    primaryLight: Color(0xFF4C988C),
    primarySoft: Color(0x26397B70),      // 15% opacity primary brand color
    onPrimary: Color(0xFFFFFFFF),         // White text on brand buttons
    accent: Color(0xFF397B70),           // Accent same as primary brand color
    accentSoft: Color(0x26397B70),
    success: Color(0xFF05A357),
    successSoft: Color(0xFF0F2A19),
    warning: Color(0xFFFBBF24),
    warningSoft: Color(0xFF30220A),
    danger: Color(0xFFE11900),
    dangerSoft: Color(0xFF321515),
    info: Color(0xFF276EF1),
    infoSoft: Color(0xFF102544),
    textPrimary: Color(0xFFFFFFFF),      // Pure white
    textSecondary: Color(0xFFB2C5C1),    // Premium teal-gray secondary text
    textTertiary: Color(0xFF7E938F),     // Mid teal-gray text
    textMuted: Color(0xFF536662),        // Dark teal-gray text
    iconPrimary: Color(0xFFFFFFFF),
    iconSecondary: Color(0xFFB2C5C1),
    border: Color(0xFF29413B),           // Soft green border
    borderSubtle: Color(0xFF1E352F),
    divider: Color(0xFF29413B),
    glass: Color(0xCC1E352F),            // Glass with deep forest green base
    glassHigh: Color(0xE61E352F),
    glassBorder: Color(0x33FFFFFF),      // Subtle overlay border for glass
    shimmerBase: Color(0xFF1E352F),
    shimmerHighlight: Color(0xFF25413A),
  );
}
