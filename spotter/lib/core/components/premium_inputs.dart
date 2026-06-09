import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/radius.dart';
import '../theme/typography.dart';

class PremiumTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool showClearButton;

  const PremiumTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.autofocus = false,
    this.focusNode,
    this.showClearButton = true,
  });

  @override
  State<PremiumTextField> createState() => _PremiumTextFieldState();
}

class _PremiumTextFieldState extends State<PremiumTextField> {
  late final FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = SpottColors.border;
    double borderWidth = 1.0;
    if (widget.errorText != null) {
      borderColor = SpottColors.danger;
      borderWidth = 1.5;
    } else if (_hasFocus) {
      borderColor = SpottColors.primary;
      borderWidth = 1.5;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.labelText,
          style: SpottTextStyles.caption.copyWith(
            color: widget.errorText != null ? SpottColors.danger : SpottColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          constraints: const BoxConstraints(minHeight: 48), // Ensure minimum 48px touch target
          decoration: BoxDecoration(
            color: SpottColors.surface2,
            borderRadius: BorderRadius.circular(SpottRadius.lg),
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
          ),
          child: ListenableBuilder(
            listenable: widget.controller,
            builder: (context, _) {
              Widget? suffixWidget;
              if (widget.showClearButton && widget.controller.text.isNotEmpty) {
                suffixWidget = GestureDetector(
                  onTap: () {
                    widget.controller.clear();
                  },
                  child: const Icon(
                    Icons.clear_rounded,
                    color: SpottColors.textTertiary,
                    size: 20,
                  ),
                );
              } else {
                suffixWidget = widget.suffixIcon;
              }

              return TextField(
                controller: widget.controller,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                onSubmitted: widget.onSubmitted,
                obscureText: widget.obscureText,
                autofocus: widget.autofocus,
                focusNode: _focusNode,
                style: SpottTextStyles.bodyLarge.copyWith(
                  color: SpottColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: SpottTextStyles.body.copyWith(color: SpottColors.textMuted),
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: suffixWidget,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  isDense: true,
                ),
              );
            },
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              widget.errorText!,
              style: SpottTextStyles.caption.copyWith(
                color: SpottColors.danger,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
