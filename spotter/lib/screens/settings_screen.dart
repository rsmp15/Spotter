import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/ride_controller.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';






class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;

    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: DSColors.textPrimary),
        title: Text('Settings', style: DSTypography.titleLarge),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: DSSpacing.md),
            Text(
              'Account, vehicles, privacy, and preferences',
              style: DSTypography.body,
            ),
            const SizedBox(height: DSSpacing.xl),
            
            Text('GENERAL', style: DSTypography.caption),
            const SizedBox(height: DSSpacing.md),
            
            GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsRow(
                    icon: Icons.person_outline_rounded,
                    title: 'Personal information',
                    detail: 'Name, phone, email',
                  ),
                  _buildDivider(),
                  _SettingsRow(
                    icon: Icons.directions_car_outlined,
                    title: 'Vehicles',
                    detail: 'My vehicles',
                  ),
                  _buildDivider(),
                  _SettingsRow(
                    icon: Icons.verified_user_outlined,
                    title: 'Verification status',
                    detail: 'KYC & Documents',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: DSSpacing.xl),
            
            Text('APP SETTINGS', style: DSTypography.caption),
            const SizedBox(height: DSSpacing.md),
            
            GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsRow(
                    icon: Icons.bookmark_outline_rounded,
                    title: 'Saved places',
                    detail: 'Home, work',
                  ),
                  _buildDivider(),
                  _SettingsRow(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    detail: 'Trips, safety',
                  ),
                  _buildDivider(),
                  _SettingsRow(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy',
                    detail: 'Location and account controls',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: DSSpacing.xl),
            
            Text('PREFERENCES', style: DSTypography.caption),
            const SizedBox(height: DSSpacing.md),
            
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.sm),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: DSColors.surface,
                      borderRadius: BorderRadius.circular(DSRadius.sm),
                    ),
                    child: Icon(
                      isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                      color: DSColors.textPrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: DSSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dark Theme', style: DSTypography.labelLarge),
                        const SizedBox(height: 2),
                        Text(
                          isDark ? 'Dark mode active' : 'Light mode active',
                          style: DSTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isDark,
                    onChanged: (val) {
                      ride.toggleDarkMode();
                    },
                    activeThumbColor: DSColors.primary,
                    activeTrackColor: DSColors.primarySoft,
                    inactiveThumbColor: DSColors.textSecondary,
                    inactiveTrackColor: DSColors.surface,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: DSSpacing.section),
            
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Log out',
                  style: DSTypography.labelLarge.copyWith(color: DSColors.danger),
                ),
              ),
            ),
            const SizedBox(height: 120.0),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 72),
      color: DSColors.borderSubtle,
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;

  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => HapticFeedback.lightImpact(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DSSpacing.md,
          vertical: DSSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: DSColors.surface,
                borderRadius: BorderRadius.circular(DSRadius.sm),
              ),
              child: Icon(icon, color: DSColors.textSecondary, size: 20),
            ),
            const SizedBox(width: DSSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: DSTypography.labelLarge),
                  const SizedBox(height: 2),
                  Text(detail, style: DSTypography.caption),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: DSColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
