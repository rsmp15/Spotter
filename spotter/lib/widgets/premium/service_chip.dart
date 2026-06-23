import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';

class ServiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ServiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: DSSpacing.lg, // 16.0
          vertical: DSSpacing.sm,  // 8.0
        ),
        decoration: BoxDecoration(
          color: isSelected ? DSColors.primary : DSColors.surfaceVariant,
          borderRadius: BorderRadius.circular(DSRadius.pill),
          border: Border.all(
            color: isSelected
                ? DSColors.primary
                : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: DSTypography.bodySMStrong.copyWith(
            color: isSelected ? DSColors.onPrimary : DSColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

