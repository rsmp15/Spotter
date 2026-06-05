import 'package:flutter/material.dart';

import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../core/theme/radius.dart';

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
    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: SpottColors.textPrimary),
        title: const Text('SPOTT', style: SpottTextStyles.sectionTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.lg, vertical: SpottSpacing.md),
        children: [
          // Header Section
          const SizedBox(height: SpottSpacing.sm),
          Text('Notifications', style: SpottTextStyles.display.copyWith(fontSize: 40)),
          const SizedBox(height: SpottSpacing.xs),
          Text('Stay updated on your journeys and earnings.', style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary)),
          const SizedBox(height: SpottSpacing.xl),

          // Smart Filter Chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (context, index) => const SizedBox(width: SpottSpacing.sm),
              itemBuilder: (context, index) {
                final isSelected = _selectedFilterIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilterIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.xl, vertical: SpottSpacing.sm),
                    decoration: BoxDecoration(
                      color: isSelected ? SpottColors.primary : Colors.white.withValues(alpha:0.6),
                      borderRadius: BorderRadius.circular(SpottRadius.pill),
                      border: Border.all(
                        color: isSelected ? Colors.transparent : Colors.white.withValues(alpha:0.8),
                      ),
                      boxShadow: isSelected
                          ? [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 4, offset: const Offset(0, 2))]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _filters[index],
                      style: SpottTextStyles.label.copyWith(
                        color: isSelected ? Colors.white : SpottColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: SpottSpacing.xxl),

          // Notification Scenes
          _NotificationCard(
            title: 'Amit accepted your ride',
            subtitle: 'Ride update',
            time: '2 minutes ago',
            icon: Icons.check_circle_rounded,
            iconColor: SpottColors.success,
            buttonLabel: 'View Details',
            onTap: () => _showNotification(context, 'Ride update opened'),
          ),
          const SizedBox(height: SpottSpacing.lg),

          _NotificationCard(
            title: 'Ride OTP generated',
            subtitle: 'Security update',
            time: 'Today',
            icon: Icons.password_rounded,
            iconColor: SpottColors.primary,
            buttonLabel: 'View Details',
            onTap: () => _showNotification(context, 'Ride OTP details opened'),
          ),
          const SizedBox(height: SpottSpacing.lg),

          _NotificationCard(
            title: 'Wallet top-up successful',
            subtitle: 'Payment received',
            time: 'Today',
            icon: Icons.account_balance_wallet_rounded,
            iconColor: SpottColors.textSecondary, // mapped from original flutter code
            buttonLabel: 'View Wallet',
            onTap: () => _showNotification(context, 'Wallet receipt opened'),
          ),
          const SizedBox(height: SpottSpacing.lg),

          _NotificationCard(
            title: 'Safety contact added',
            subtitle: 'Account updated',
            time: 'Yesterday',
            icon: Icons.security_rounded,
            iconColor: SpottColors.warning,
            buttonLabel: 'View Details',
            onTap: () => _showNotification(context, 'Safety contact opened'),
          ),
        ],
      ),
    );
  }

  void _showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconColor;
  final String buttonLabel;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.buttonLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(SpottSpacing.lg),
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
                  color: iconColor.withValues(alpha:0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: SpottSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: SpottTextStyles.headline.copyWith(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary)),
                    const SizedBox(height: 8),
                    Text(time, style: SpottTextStyles.caption.copyWith(color: SpottColors.textSecondary.withValues(alpha:0.6))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: SpottSpacing.lg),
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
