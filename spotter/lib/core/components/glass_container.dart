import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/radius.dart';

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
      padding: padding ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: SpottColors.surface1, // Solid white surface
        borderRadius: BorderRadius.circular(borderRadius),
        border: hasBorder
            ? Border.all(
                color: SpottColors.border,
                width: 1.0,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
