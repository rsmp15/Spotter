import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

import 'spott_buttons.dart';

/// Branded empty state with emotional messaging and illustration.
/// Replaces generic "No data" screens with personality.
class BrandedEmptyState extends StatelessWidget {
  final String headline;
  final String description;
  final IconData icon;
  final Color? iconColor;
  final String? actionLabel;
  final VoidCallback? onAction;

  const BrandedEmptyState({
    super.key,
    required this.headline,
    required this.description,
    required this.icon,
    this.iconColor,
    this.actionLabel,
    this.onAction,
  });

  // ── Preset factories ──────────────────────────────────────────────
  const BrandedEmptyState.noTrips({
    super.key,
    this.onAction,
  })  : headline = 'Your next shared journey starts here',
        description =
            'Find a trip, share the cost, and travel with verified companions.',
        icon = Icons.route_rounded,
        iconColor = null,
        actionLabel = 'Find a trip';

  const BrandedEmptyState.noResults({
    super.key,
    this.onAction,
  })  : headline = 'No direct travelers found for this route yet',
        description =
            'Try expanding your search radius, selecting nearby departure times, or check upcoming popular routes.',
        icon = Icons.search_off_rounded,
        iconColor = null,
        actionLabel = 'Expand Search Radius';

  const BrandedEmptyState.noNotifications({
    super.key,
    this.onAction,
  })  : headline = 'All caught up',
        description = 'When something important happens, you\'ll see it here.',
        icon = Icons.notifications_none_rounded,
        iconColor = null,
        actionLabel = null;

  const BrandedEmptyState.noMessages({
    super.key,
    this.onAction,
  })  : headline = 'No conversations yet',
        description =
            'Messages with travelers and drivers will appear here.',
        icon = Icons.chat_bubble_outline_rounded,
        iconColor = null,
        actionLabel = null;

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? SpottColors.accentPurple;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated illustration ring
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.08),
              ),
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.15),
                  ),
                  child: Icon(icon, size: 36, color: color),
                ),
              ),
            ),
            const SizedBox(height: SpottSpacing.xl),

            // Emotional headline
            Text(
              headline,
              textAlign: TextAlign.center,
              style: SpottTextStyles.title.copyWith(
                height: 1.3,
              ),
            ),
            const SizedBox(height: SpottSpacing.sm),

            // Descriptive subtitle
            Text(
              description,
              textAlign: TextAlign.center,
              style: SpottTextStyles.body.copyWith(
                color: SpottColors.textTertiary,
                height: 1.5,
              ),
            ),

            // CTA button
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: SpottSpacing.xl),
              SizedBox(
                width: 200,
                child: SpottButton.primary(
                  label: actionLabel!,
                  onPressed: onAction,
                  size: SpottButtonSize.small,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
