import 'package:spotter/design_system/design_system.dart';
import 'dart:ui';
import 'package:flutter/material.dart';




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
    super.key,
    required this.child,
    this.borderRadius = DSRadius.lg,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.blur = 10.0,
    this.color,
    this.border,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: DSShadows.elevation2,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: color ?? Color(0x1A000000).withValues(alpha: 0.1),
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
