import 'dart:ui';
import 'package:flutter/material.dart';
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
    this.blurSigma = 16.0,
    this.borderRadius = SpottRadius.xl,
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
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: SpottShadows.elevation2,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding ?? EdgeInsets.zero,
            decoration: BoxDecoration(
              gradient:
                  gradient ??
                  LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.07),
                      Colors.white.withValues(alpha: 0.02),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
              borderRadius: BorderRadius.circular(borderRadius),
              border: hasBorder
                  ? Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                      width: 1.0,
                    )
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
