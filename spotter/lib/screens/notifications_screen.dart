import 'package:flutter/material.dart';

import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../core/theme/radius.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: SpottColors.textPrimary),
        title: const Text('Notifications', style: SpottTextStyles.sectionTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(SpottSpacing.lg),
        children: [
          Text('Important ride updates.', style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary)),
          const SizedBox(height: SpottSpacing.xl),

          _NotificationTile(
            title: 'Amit accepted your ride',
            time: '2 minutes ago',
            onTap: () => _showNotification(context, 'Ride update opened'),
            icon: Icons.check_circle_rounded,
            iconColor: SpottColors.success,
          ),
          const SizedBox(height: SpottSpacing.md),
          
          _NotificationTile(
            title: 'Ride OTP generated',
            time: 'Today',
            onTap: () => _showNotification(context, 'Ride OTP details opened'),
            icon: Icons.password_rounded,
            iconColor: SpottColors.primary,
          ),
          const SizedBox(height: SpottSpacing.md),
          
          _NotificationTile(
            title: 'Wallet top-up successful',
            time: 'Today',
            onTap: () => _showNotification(context, 'Wallet receipt opened'),
            icon: Icons.account_balance_wallet_rounded,
            iconColor: SpottColors.textSecondary,
          ),
          const SizedBox(height: SpottSpacing.md),
          
          _NotificationTile(
            title: 'Safety contact added',
            time: 'Yesterday',
            onTap: () => _showNotification(context, 'Safety contact opened'),
            icon: Icons.security_rounded,
            iconColor: SpottColors.warning,
          ),
        ],
      ),
    );
  }

  void _showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String time;
  final VoidCallback onTap;
  final IconData icon;
  final Color iconColor;

  const _NotificationTile({
    required this.title,
    required this.time,
    required this.onTap,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(SpottSpacing.md),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: SpottColors.surface1,
              borderRadius: BorderRadius.circular(SpottRadius.sm),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: SpottSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: SpottTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: SpottColors.textPrimary)),
                const SizedBox(height: 2),
                Text(time, style: SpottTextStyles.caption),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: SpottColors.textSecondary),
        ],
      ),
    );
  }
}
