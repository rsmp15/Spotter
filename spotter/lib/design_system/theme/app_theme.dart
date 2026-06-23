
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// Central theme builder for the Spotter design system.
class AppTheme {
  AppTheme._();

  static ThemeData get light => fromPalette(DSPalettes.light);

  static ThemeData get dark => fromPalette(DSPalettes.dark);

  static ThemeData fromPalette(DSColorPalette palette) {
    final colorScheme = palette.colorScheme;
    final isDark = palette.isDark;
    return ThemeData(
      useMaterial3: true,
      brightness: palette.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: palette.background,
      canvasColor: palette.background,
      cardColor: palette.card,
      dividerColor: palette.divider,
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        foregroundColor: palette.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle:
            DSTypography.headline.copyWith(color: palette.textPrimary),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.onPrimary,
          disabledBackgroundColor: palette.border,
          disabledForegroundColor: palette.textMuted,
          textStyle: DSTypography.labelLarge.copyWith(color: palette.onPrimary),
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DSRadius.button),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.onPrimary,
          disabledBackgroundColor: palette.border,
          disabledForegroundColor: palette.textMuted,
          textStyle: DSTypography.labelLarge.copyWith(color: palette.onPrimary),
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DSRadius.button),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primary,
          textStyle: DSTypography.labelLarge.copyWith(color: palette.primary),
          minimumSize: const Size(48, 48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.textPrimary,
          minimumSize: const Size.fromHeight(56),
          side: BorderSide(color: palette.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DSRadius.button),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DSSpacing.card,
          vertical: DSSpacing.formField,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DSRadius.input),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DSRadius.input),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DSRadius.input),
          borderSide: BorderSide(color: palette.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DSRadius.input),
          borderSide: BorderSide(color: palette.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DSRadius.input),
          borderSide: BorderSide(color: palette.danger, width: 1.5),
        ),
      ),
      textTheme: (!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST')
              ? const TextTheme()
              : GoogleFonts.interTextTheme())
          .copyWith(
        displayLarge:
            DSTypography.displayLarge.copyWith(color: palette.textPrimary),
        headlineLarge:
            DSTypography.headline.copyWith(color: palette.textPrimary),
        titleLarge:
            DSTypography.titleLarge.copyWith(color: palette.textPrimary),
        bodyLarge:
            DSTypography.bodyLarge.copyWith(color: palette.textSecondary),
        bodyMedium: DSTypography.body.copyWith(color: palette.textSecondary),
        labelLarge:
            DSTypography.labelLarge.copyWith(color: palette.textPrimary),
        bodySmall: DSTypography.caption.copyWith(color: palette.textTertiary),
      ),
      cardTheme: CardThemeData(
        color: palette.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DSRadius.card),
          side: BorderSide(color: palette.border, width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: palette.surfaceVariant,
        selectedColor: palette.primarySoft,
        disabledColor: palette.borderSubtle,
        labelStyle: DSTypography.caption.copyWith(color: palette.textSecondary),
        secondaryLabelStyle:
            DSTypography.caption.copyWith(color: palette.primary),
        side: BorderSide(color: palette.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DSRadius.pill),
        ),
      ),
      iconTheme: IconThemeData(color: palette.iconPrimary),
      shadowColor: isDark ? Colors.black : palette.border,
      bottomAppBarTheme: BottomAppBarThemeData(
        color: palette.surface,
        elevation: 0,
      ),
      dividerTheme: DividerThemeData(
        color: palette.divider,
        thickness: 1,
      ),
    );
  }
}

