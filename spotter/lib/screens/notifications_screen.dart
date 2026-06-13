import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../core/components/glass_card.dart';
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
    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: DSColors.textPrimary),
        title: Text('SPOTT', style: DSTypography.headline),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: DSSpacing.lg, vertical: DSSpacing.md),
        children: [
          // Header Section
          const SizedBox(height: DSSpacing.sm),
          Text('Notifications', style: DSTypography.headline.copyWith(fontSize: 40)),
          const SizedBox(height: DSSpacing.xs),
          Text('Stay updated on your journeys and earnings.', style: DSTypography.body.copyWith(color: DSColors.textSecondary)),
          const SizedBox(height: DSSpacing.xl),

          // Smart Filter Chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (context, index) => const SizedBox(width: DSSpacing.sm),
              itemBuilder: (context, index) {
                final isSelected = _selectedFilterIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilterIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: DSSpacing.xl, vertical: DSSpacing.sm),
                    decoration: BoxDecoration(
                      color: isSelected ? DSColors.primary : Colors.white.withValues(alpha:0.6),
                      borderRadius: BorderRadius.circular(DSRadius.pill),
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
                      style: DSTypography.labelLarge.copyWith(
                        color: isSelected ? Colors.white : DSColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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
            icon: Icons.check_circle_rounded,
            iconColor: DSColors.success,
            buttonLabel: 'View Details',
            onTap: () => _showNotification(context, 'Ride update opened'),
          ),
          const SizedBox(height: DSSpacing.lg),

          _NotificationCard(
            title: 'Ride OTP generated',
            subtitle: 'Security update',
            time: 'Today',
            icon: Icons.password_rounded,
            iconColor: DSColors.primary,
            buttonLabel: 'View Details',
            onTap: () => _showNotification(context, 'Ride OTP details opened'),
          ),
          const SizedBox(height: DSSpacing.lg),

          _NotificationCard(
            title: 'Wallet top-up successful',
            subtitle: 'Payment received',
            time: 'Today',
            icon: Icons.account_balance_wallet_rounded,
            iconColor: DSColors.textSecondary, // mapped from original flutter code
            buttonLabel: 'View Wallet',
            onTap: () => _showNotification(context, 'Wallet receipt opened'),
          ),
          const SizedBox(height: DSSpacing.lg),

          _NotificationCard(
            title: 'Safety contact added',
            subtitle: 'Account updated',
            time: 'Yesterday',
            icon: Icons.security_rounded,
            iconColor: DSColors.warning,
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
      padding: const EdgeInsets.all(DSSpacing.lg),
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
              const SizedBox(width: DSSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: DSTypography.headline.copyWith(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: DSTypography.body.copyWith(color: DSColors.textSecondary)),
                    const SizedBox(height: 8),
                    Text(time, style: DSTypography.caption.copyWith(color: DSColors.textSecondary.withValues(alpha:0.6))),
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
