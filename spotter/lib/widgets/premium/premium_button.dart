import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';

enum PremiumButtonVariant {
  primary, // button-primary (black pill)
  secondary, // button-secondary (white pill)
  subtle, // button-subtle (gray pill)
  largeRounded, // button-large-rounded (black 16px radius)
}

class PremiumButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary; // Kept for backward compatibility
  final PremiumButtonVariant? variant;
  final IconData? icon;
  final bool isLoading;

  const PremiumButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.variant,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveVariant = widget.variant ??
        (widget.isPrimary
            ? PremiumButtonVariant.primary
            : PremiumButtonVariant.subtle);

    Color? backgroundColor;
    Color textColor;
    double borderRadiusVal = DSRadius.pill;
    List<BoxShadow> shadows = DSShadows.level0;
    Border? border;

    switch (effectiveVariant) {
      case PremiumButtonVariant.primary:
        backgroundColor = DSColors.primary; // Ink Black
        textColor = DSColors.onPrimary; // On Dark (white)
        borderRadiusVal = DSRadius.pill;
        break;
      case PremiumButtonVariant.secondary:
        backgroundColor = DSColors.background; // Canvas White
        textColor = DSColors.textPrimary; // Ink Black
        borderRadiusVal = DSRadius.pill;
        border = Border.all(color: DSColors.border);
        shadows = DSShadows.level3; // Pill Float
        break;
      case PremiumButtonVariant.subtle:
        backgroundColor = DSColors.surfaceVariant; // Canvas Soft (#efefef)
        textColor = DSColors.textPrimary; // Ink Black
        borderRadiusVal = DSRadius.pill;
        break;
      case PremiumButtonVariant.largeRounded:
        backgroundColor = DSColors.primary; // Ink Black
        textColor = DSColors.onPrimary; // On Dark (white)
        borderRadiusVal = DSRadius.xl; // 16px
        break;
    }

    final TextStyle textStyle = effectiveVariant == PremiumButtonVariant.largeRounded
        ? DSTypography.buttonLarge.copyWith(color: textColor)
        : DSTypography.buttonMD.copyWith(color: textColor);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: effectiveVariant == PremiumButtonVariant.largeRounded
                ? DSSpacing.lg
                : DSSpacing.md,
            horizontal: DSSpacing.lg,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadiusVal),
            color: backgroundColor,
            border: border,
            boxShadow: shadows,
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: textColor,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: textColor, size: 20),
                        const SizedBox(width: DSSpacing.sm),
                      ],
                      Text(
                        widget.text,
                        style: textStyle,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

