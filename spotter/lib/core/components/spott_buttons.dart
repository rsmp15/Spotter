import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/colors.dart';
import '../theme/radius.dart';
import '../theme/spacing.dart';
import '../theme/shadows.dart';
import '../theme/animations.dart';
import '../theme/gradients.dart';
import 'glass_container.dart';

enum SpottButtonVariant { primary, secondary, ghost, danger }
enum SpottButtonSize { normal, small }

class SpottButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final SpottButtonVariant variant;
  final SpottButtonSize size;
  final bool isLoading;
  final Widget? icon;
  final bool isFullWidth;

  const SpottButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = SpottButtonVariant.primary,
    this.size = SpottButtonSize.normal,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
  });

  const SpottButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = SpottButtonSize.normal,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
  }) : variant = SpottButtonVariant.primary;

  const SpottButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = SpottButtonSize.normal,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
  }) : variant = SpottButtonVariant.secondary;

  const SpottButton.ghost({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = SpottButtonSize.normal,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
  }) : variant = SpottButtonVariant.ghost;

  const SpottButton.danger({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = SpottButtonSize.normal,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
  }) : variant = SpottButtonVariant.danger;

  @override
  State<SpottButton> createState() => _SpottButtonState();
}

class _SpottButtonState extends State<SpottButton>
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
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: SpottCurves.decelerate),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  double get _height =>
      widget.size == SpottButtonSize.small ? 44.0 : 56.0;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null || widget.isLoading;

    if (widget.variant == SpottButtonVariant.ghost) {
      return _buildAnimatedWrapper(
        child: _buildGhost(isDisabled),
        isDisabled: isDisabled,
      );
    }

    return _buildAnimatedWrapper(
      isDisabled: isDisabled,
      child: Container(
        width: widget.isFullWidth ? double.infinity : null,
        height: _height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SpottRadius.pill),
          gradient: _gradient,
          boxShadow: isDisabled ? null : _shadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : () {
              HapticFeedback.lightImpact();
              widget.onPressed?.call();
            },
            borderRadius: BorderRadius.circular(SpottRadius.pill),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.isFullWidth ? 0 : SpottSpacing.xl),
              child: Center(
                widthFactor: widget.isFullWidth ? null : 1.0,
                child: _buildContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedWrapper({
    required Widget child,
    required bool isDisabled,
  }) {
    if (isDisabled) return child;

    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) => _pressController.reverse(),
      onTapCancel: () => _pressController.reverse(),
      child: AnimatedBuilder(
        animation: _pressController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnim.value,
            child: child,
          );
        },
        child: child,
      ),
    );
  }

  LinearGradient get _gradient {
    switch (widget.variant) {
      case SpottButtonVariant.primary:
        return SpottGradients.primary;
      case SpottButtonVariant.secondary:
        return SpottGradients.accent;
      case SpottButtonVariant.danger:
        return const LinearGradient(
          colors: [SpottColors.danger, Color(0xFFC41830)],
        );
      default:
        return SpottGradients.primary;
    }
  }

  List<BoxShadow>? get _shadow {
    switch (widget.variant) {
      case SpottButtonVariant.primary:
        return SpottShadows.glowPrimary;
      case SpottButtonVariant.secondary:
        return SpottShadows.glowPurple;
      case SpottButtonVariant.danger:
        return SpottShadows.glowPrimary;
      default:
        return null;
    }
  }

  Widget _buildGhost(bool isDisabled) {
    return GlassContainer(
      height: _height,
      width: widget.isFullWidth ? double.infinity : null,
      borderRadius: SpottRadius.pill,
      hasBorder: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : () {
            HapticFeedback.lightImpact();
            widget.onPressed?.call();
          },
          borderRadius: BorderRadius.circular(SpottRadius.pill),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.isFullWidth ? 0 : SpottSpacing.xl),
            child: Center(
              widthFactor: widget.isFullWidth ? null : 1.0,
              child: _buildContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final double fontSize =
        widget.size == SpottButtonSize.small ? 14.0 : 16.0;

    if (widget.isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          color: SpottColors.textPrimary,
          strokeWidth: 2.5,
          strokeCap: StrokeCap.round,
        ),
      );
    }

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.icon!,
          const SizedBox(width: SpottSpacing.sm),
          Text(
            widget.label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: SpottColors.textPrimary,
              fontFamily: 'Inter',
            ),
          ),
        ],
      );
    }

    return Text(
      widget.label,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: SpottColors.textPrimary,
        fontFamily: 'Inter',
      ),
    );
  }
}
