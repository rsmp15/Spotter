import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/radius.dart';
import '../../core/theme/shadows.dart';

class Glassmorphism extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double blur;
  final Color? color;
  final Border? border;
  final double? width;
  final double? height;

  const Glassmorphism({
    Key? key,
    required this.child,
    this.borderRadius = SpottRadius.lg,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.blur = 10.0,
    this.color,
    this.border,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: SpottShadows.elevation2,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: color ?? SpottColors.overlayPressed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(borderRadius),
              border:
                  border ??
                  Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1.0,
                  ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
