import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/radius.dart';
import '../theme/shadows.dart';

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
    this.blurSigma = 8.0,
    this.borderRadius = SpottRadius.card,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.hasBorder = true,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: gradient == null ? SpottColors.surface3 : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: hasBorder
            ? Border.all(color: SpottColors.border, width: 1.0)
            : null,
        boxShadow: SpottShadows.elevation1,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}
