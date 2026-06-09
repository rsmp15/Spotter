import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/radius.dart';

enum ChipStatus { verified, pending, approved, rejected, delivered, inTransit, neutral }

class StatusChip extends StatelessWidget {
  final String label;
  final ChipStatus status;
  final IconData? icon;

  const StatusChip({
    super.key,
    required this.label,
    this.status = ChipStatus.neutral,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getBgColor(),
        borderRadius: BorderRadius.circular(SpottRadius.pill),
        border: Border.all(color: _getBorderColor(), width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: _getTextColor()),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _getTextColor(),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Color _getBgColor() {
    switch (status) {
      case ChipStatus.verified:
      case ChipStatus.approved:
      case ChipStatus.delivered:
        return SpottColors.success.withValues(alpha: 0.14);
      case ChipStatus.pending:
      case ChipStatus.inTransit:
        return SpottColors.warning.withValues(alpha: 0.14);
      case ChipStatus.rejected:
        return SpottColors.danger.withValues(alpha: 0.14);
      case ChipStatus.neutral:
        return SpottColors.surface2;
    }
  }

  Color _getBorderColor() {
    switch (status) {
      case ChipStatus.verified:
      case ChipStatus.approved:
      case ChipStatus.delivered:
        return SpottColors.success.withValues(alpha: 0.3);
      case ChipStatus.pending:
      case ChipStatus.inTransit:
        return SpottColors.warning.withValues(alpha: 0.3);
      case ChipStatus.rejected:
        return SpottColors.danger.withValues(alpha: 0.3);
      case ChipStatus.neutral:
        return SpottColors.border;
    }
  }

  Color _getTextColor() {
    switch (status) {
      case ChipStatus.verified:
      case ChipStatus.approved:
      case ChipStatus.delivered:
        return SpottColors.success;
      case ChipStatus.pending:
      case ChipStatus.inTransit:
        return SpottColors.warning;
      case ChipStatus.rejected:
        return SpottColors.danger;
      case ChipStatus.neutral:
        return SpottColors.textSecondary;
    }
  }
}
