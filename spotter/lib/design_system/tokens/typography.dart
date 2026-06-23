import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Canonical typography tokens for the Spotter design system based on Uber Base.
class DSTypography {
  DSTypography._();

  static const String primaryFontFamily = 'Inter';
  static const String displayFontFamily = 'Inter';

  static TextStyle _font(String family, TextStyle style) {
    if (!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST')) {
      return style.copyWith(fontFamily: family);
    }
    return GoogleFonts.inter(
      fontSize: style.fontSize,
      fontWeight: style.fontWeight,
      letterSpacing: style.letterSpacing,
      height: style.height,
    );
  }

  // Display Sans (UberMove equivalent) - Weight 700, no tracking, tight heights (1.22-1.25)
  static TextStyle get displayXXL => _font(
        displayFontFamily,
        const TextStyle(
          fontSize: 52,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.0,
          height: 1.23, // 64px / 52px
        ),
      );

  static TextStyle get displayXL => _font(
        displayFontFamily,
        const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.0,
          height: 1.22, // 44px / 36px
        ),
      );

  static TextStyle get displayLG => _font(
        displayFontFamily,
        const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.0,
          height: 1.25, // 40px / 32px
        ),
      );

  static TextStyle get displayMD => _font(
        displayFontFamily,
        const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.0,
          height: 1.33, // 32px / 24px
        ),
      );

  static TextStyle get displaySM => _font(
        displayFontFamily,
        const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.0,
          height: 1.4, // 28px / 20px
        ),
      );

  // Text Sans (UberMoveText equivalent) - Weights 400 and 500
  static TextStyle get bodyLG => _font(
        primaryFontFamily,
        const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          height: 1.33, // 24px / 18px
        ),
      );

  static TextStyle get bodyMD => _font(
        primaryFontFamily,
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5, // 24px / 16px
        ),
      );

  static TextStyle get bodyMDStrong => _font(
        primaryFontFamily,
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.25, // 20px / 16px
        ),
      );

  static TextStyle get bodySM => _font(
        primaryFontFamily,
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.43, // 20px / 14px
        ),
      );

  static TextStyle get bodySMStrong => _font(
        primaryFontFamily,
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.14, // 16px / 14px
        ),
      );

  static TextStyle get caption => _font(
        primaryFontFamily,
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.67, // 20px / 12px
        ),
      );

  static TextStyle get buttonLarge => _font(
        primaryFontFamily,
        const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          height: 1.33, // 24px / 18px
        ),
      );

  static TextStyle get buttonMD => _font(
        primaryFontFamily,
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.25, // 20px / 16px
        ),
      );

  // Legacy mappings to prevent compilation errors
  static TextStyle get displayLarge => displayLG;
  static TextStyle get headline => displayMD;
  static TextStyle get titleLarge => displaySM;
  static TextStyle get bodyLarge => bodyLG;
  static TextStyle get body => bodyMD;
  static TextStyle get labelLarge => bodyMDStrong;

  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLG,
        headlineLarge: displayMD,
        titleLarge: displaySM,
        bodyLarge: bodyLG,
        bodyMedium: bodyMD,
        labelLarge: bodyMDStrong,
        bodySmall: caption,
      );
}

