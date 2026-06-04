import 'package:flutter/material.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';
import '../theme/colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SpottSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: SpottTextStyles.sectionTitle),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: SpottTextStyles.caption.copyWith(color: SpottColors.textTertiary),
                  ),
                ],
              ],
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: SpottColors.primary,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}
