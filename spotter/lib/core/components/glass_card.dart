import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/radius.dart';
import '../theme/spacing.dart';
import '../theme/animations.dart';
import 'glass_container.dart';

class GlassCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(SpottSpacing.md),
    this.gradient,
    this.borderRadius = SpottRadius.card,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: SpottAnimations.instant,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressController, curve: SpottCurves.decelerate),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final card = GlassContainer(
      borderRadius: widget.borderRadius,
      padding: widget.padding,
      gradient: widget.gradient,
      child: widget.child,
    );

    if (widget.onTap != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: SpottSpacing.md),
        child: AnimatedBuilder(
          animation: _pressController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnim.value,
              child: child,
            );
          },
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTapDown: (_) => _pressController.forward(),
              onTapUp: (_) {
                _pressController.reverse();
                HapticFeedback.lightImpact();
                widget.onTap?.call();
              },
              onTapCancel: () => _pressController.reverse(),
              child: card,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: SpottSpacing.md),
      child: card,
    );
  }
}
