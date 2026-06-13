import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Shimmer loading placeholder for skeleton screens.
/// Use in place of content while data is loading.
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final bool isCircle;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 8.0,
    this.isCircle = false,
  });

  /// Pill-shaped shimmer for text lines
  const ShimmerLoading.text({
    super.key,
    this.width = 120,
    this.height = 14,
  })  : borderRadius = 7.0,
        isCircle = false;

  /// Circular shimmer for avatars
  const ShimmerLoading.circle({
    super.key,
    required double radius,
  })  : width = radius * 2,
        height = radius * 2,
        borderRadius = radius,
        isCircle = true;

  /// Card-shaped shimmer
  const ShimmerLoading.card({
    super.key,
    this.width = double.infinity,
    this.height = 80,
  })  : borderRadius = 20.0,
        isCircle = false;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.isCircle
                ? null
                : BorderRadius.circular(widget.borderRadius),
            shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(1.0 + 2.0 * _controller.value, 0),
              colors: const [
                DSColors.shimmerBase,
                DSColors.shimmerHighlight,
                DSColors.shimmerBase,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}
