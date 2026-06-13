import 'package:spotter/design_system/design_system.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blurSigma;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final bool hasBorder;
  final Gradient? gradient;

  const GlassContainer({
    super.key,
    required this.child,
    this.blurSigma = 0.0,
    this.borderRadius = DSRadius.card,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.hasBorder = true,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final hasBlur = blurSigma > 0.0;
    
    final decoration = BoxDecoration(
      color: hasBlur
          ? Colors.white.withValues(alpha: 0.8) // Frosted glass overlay
          : DSColors.surface,
      borderRadius: BorderRadius.circular(borderRadius),
      border: hasBorder
          ? Border.all(
              color: DSColors.border,
              width: 1.0,
            )
          : null,
      gradient: gradient,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );

    if (hasBlur) {
      return Container(
        width: width,
        height: height,
        margin: margin,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Container(
              padding: padding ?? EdgeInsets.zero,
              decoration: decoration,
              child: child,
            ),
          ),
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? EdgeInsets.zero,
      decoration: decoration,
      child: child,
    );
  }
}
