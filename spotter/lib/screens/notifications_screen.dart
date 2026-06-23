import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotter/design_system/design_system.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'Trips', 'Parcels', 'Payments', 'Safety'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;
    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.arrow_left,
            color: palette.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'SPOTT',
          style: DSTypography.headline.copyWith(
            color: palette.textPrimary,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: DSSpacing.lg, vertical: DSSpacing.md),
        children: [
          // Header Section
          const SizedBox(height: DSSpacing.sm),
          Text(
            'Notifications',
            style: DSTypography.headline.copyWith(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: DSSpacing.xs),
          Text(
            'Stay updated on your journeys and earnings.',
            style: DSTypography.body.copyWith(
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: DSSpacing.xl),

          // Smart Filter Chips
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (context, index) => const SizedBox(width: DSSpacing.sm),
              itemBuilder: (context, index) {
                final isSelected = _selectedFilterIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilterIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: DSSpacing.lg),
                    decoration: BoxDecoration(
                      color: isSelected ? palette.textPrimary : palette.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.transparent : palette.border,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _filters[index],
                      style: DSTypography.labelLarge.copyWith(
                        color: isSelected ? palette.background : palette.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: DSSpacing.xxl),

          // Notification Scenes
          _NotificationCard(
            title: 'Amit accepted your ride',
            subtitle: 'Ride update',
            time: '2 minutes ago',
            icon: CupertinoIcons.checkmark_circle_fill,
            buttonLabel: 'View Details',
            onTap: () => _showNotification(context, 'Ride update opened'),
          ),
          const SizedBox(height: DSSpacing.lg),

          _NotificationCard(
            title: 'Ride OTP generated',
            subtitle: 'Security update',
            time: 'Today',
            icon: CupertinoIcons.lock_shield,
            buttonLabel: 'View Details',
            onTap: () => _showNotification(context, 'Ride OTP details opened'),
          ),
          const SizedBox(height: DSSpacing.lg),

          _NotificationCard(
            title: 'Wallet top-up successful',
            subtitle: 'Payment received',
            time: 'Today',
            icon: CupertinoIcons.creditcard_fill,
            buttonLabel: 'View Wallet',
            onTap: () => _showNotification(context, 'Wallet receipt opened'),
          ),
          const SizedBox(height: DSSpacing.lg),

          _NotificationCard(
            title: 'Safety contact added',
            subtitle: 'Account updated',
            time: 'Yesterday',
            icon: CupertinoIcons.shield_fill,
            buttonLabel: 'View Details',
            onTap: () => _showNotification(context, 'Safety contact opened'),
          ),
        ],
      ),
    );
  }

  void _showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Inter', color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final String buttonLabel;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.buttonLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;
    return Container(
      padding: const EdgeInsets.all(DSSpacing.lg),
      decoration: BoxDecoration(
        color: palette.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: palette.border,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: palette.textPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: DSSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: DSTypography.headline.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: DSTypography.body.copyWith(
                        fontSize: 14,
                        color: palette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      time,
                      style: DSTypography.caption.copyWith(
                        color: palette.textSecondary.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: DSSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: SpottButton.secondary(
              label: buttonLabel,
              onPressed: onTap,
            ),
          ),
        ],
      ),
    );
  }
}


