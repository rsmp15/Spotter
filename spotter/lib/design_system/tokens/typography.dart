import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Canonical typography tokens for the Spotter design system.
class DSTypography {
  DSTypography._();

  static const String primaryFontFamily = 'Inter';
  static const String displayFontFamily = 'Playfair Display';

  static TextStyle _font(String family, TextStyle style) {
    if (!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST')) {
      return style.copyWith(fontFamily: family);
    }
    return family == 'Playfair Display'
        ? GoogleFonts.playfairDisplay(
            fontSize: style.fontSize,
            fontWeight: style.fontWeight,
            letterSpacing: style.letterSpacing,
            height: style.height,
          )
        : GoogleFonts.inter(
            fontSize: style.fontSize,
            fontWeight: style.fontWeight,
            letterSpacing: style.letterSpacing,
            height: style.height,
          );
  }

  static TextStyle get displayXL => _font(
        displayFontFamily,
        const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.6,
          height: 1.1,
        ),
      );

  static TextStyle get displayLarge => _font(
        displayFontFamily,
        const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
          height: 1.15,
        ),
      );

  static TextStyle get headline => _font(
        primaryFontFamily,
        const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          height: 1.2,
        ),
      );

  static TextStyle get titleLarge => _font(
        primaryFontFamily,
        const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.1,
          height: 1.3,
        ),
      );

  static TextStyle get bodyLarge => _font(
        primaryFontFamily,
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
      );

  static TextStyle get body => _font(
        primaryFontFamily,
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
      );

  static TextStyle get labelLarge => _font(
        primaryFontFamily,
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          height: 1.3,
        ),
      );

  static TextStyle get caption => _font(
        primaryFontFamily,
        const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.0,
          height: 1.4,
        ),
      );

  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        headlineLarge: headline,
        titleLarge: titleLarge,
        bodyLarge: bodyLarge,
        bodyMedium: body,
        labelLarge: labelLarge,
        bodySmall: caption,
      );
}
