import 'package:flutter/material.dart';
import '../../theme/spott_theme.dart';

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
          horizontal: SpottTheme.spacingLarge,
          vertical: SpottTheme.spacingSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected ? SpottTheme.primary : SpottTheme.surface,
          borderRadius: BorderRadius.circular(SpottTheme.radiusXLarge),
          border: Border.all(
            color: isSelected
                ? SpottTheme.primary
                : Colors.white.withValues(alpha: 0.05),
          ),
          boxShadow: isSelected ? SpottTheme.glowingShadow : [],
        ),
        child: Text(
          label,
          style: SpottTheme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? Colors.white : SpottTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
