import 'package:flutter/material.dart';
import '../../theme/spott_theme.dart';
import 'glassmorphism.dart';

class TrustBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? color;

  const TrustBadge({
    super.key,
    required this.label,
    this.icon = Icons.check_circle_rounded,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? SpottTheme.success;

    return Glassmorphism(
      borderRadius: SpottTheme.radiusMedium,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      color: badgeColor.withValues(alpha: 0.1),
      border: Border.all(color: badgeColor.withValues(alpha: 0.3), width: 1),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: SpottTheme.textTheme.labelMedium?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
