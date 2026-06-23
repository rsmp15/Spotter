import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/animations.dart';

class MarketplaceCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const MarketplaceCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(DSSpacing.md),
    this.borderRadius = 16,
  });

  @override
  State<MarketplaceCard> createState() => _MarketplaceCardState();
}

class _MarketplaceCardState extends State<MarketplaceCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: DSMotion.instant,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.98).animate(
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
    final card = Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: DSColors.card,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: DSColors.border,
        ),
      ),
      child: widget.child,
    );

    if (widget.onTap != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: DSSpacing.md),
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
      padding: const EdgeInsets.only(bottom: DSSpacing.md),
      child: card,
    );
  }
}

