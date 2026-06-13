import 'dart:convert';

import 'colors.dart';
import 'motion.dart';
import 'radius.dart';
import 'spacing.dart';

/// Machine-readable token export for Figma sync and cross-platform parity.
class DSTokenJson {
  DSTokenJson._();

  static Map<String, Object> asMap() {
    return {
      'color': {
        'light': DSPalettes.light.toTokenJson(),
        'dark': DSPalettes.dark.toTokenJson(),
      },
      'spacing': {
        'xs': DSSpacing.xs,
        'sm': DSSpacing.sm,
        'md': DSSpacing.md,
        'lg': DSSpacing.lg,
        'xl': DSSpacing.xl,
        'xxl': DSSpacing.xxl,
        'pageInset': DSSpacing.pageInset,
        'section': DSSpacing.section,
        'card': DSSpacing.card,
        'formField': DSSpacing.formField,
        'control': DSSpacing.control,
      },
      'radius': {
        'xs': DSRadius.xs,
        'sm': DSRadius.sm,
        'md': DSRadius.md,
        'lg': DSRadius.lg,
        'xl': DSRadius.xl,
        'button': DSRadius.button,
        'card': DSRadius.card,
        'input': DSRadius.input,
        'bottomSheet': DSRadius.bottomSheet,
        'dialog': DSRadius.dialog,
        'pill': DSRadius.pill,
      },
      'motion': {
        'instantMs': DSMotion.instant.inMilliseconds,
        'fastMs': DSMotion.fast.inMilliseconds,
        'mediumMs': DSMotion.medium.inMilliseconds,
        'slowMs': DSMotion.slow.inMilliseconds,
        'extraSlowMs': DSMotion.extraSlow.inMilliseconds,
      },
    };
  }

  static String encode({bool pretty = true}) {
    final encoder = pretty
        ? const JsonEncoder.withIndent('  ')
        : const JsonEncoder();
    return encoder.convert(asMap());
  }
}
