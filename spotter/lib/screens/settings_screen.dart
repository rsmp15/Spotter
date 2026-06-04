import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../core/theme/radius.dart';

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
        leading: const BackButton(color: SpottColors.textPrimary),
        title: const Text('Settings', style: SpottTextStyles.titleSmall),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.pageHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: SpottSpacing.md),
            Text(
              'Account, vehicles, privacy, and preferences',
              style: SpottTextStyles.body,
            ),
            const SizedBox(height: SpottSpacing.xl),
            
            Text('GENERAL', style: SpottTextStyles.overline),
            const SizedBox(height: SpottSpacing.md),
            
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
            
            const SizedBox(height: SpottSpacing.xl),
            
            Text('APP SETTINGS', style: SpottTextStyles.overline),
            const SizedBox(height: SpottSpacing.md),
            
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
            
            const SizedBox(height: SpottSpacing.xl),
            
            Text('PREFERENCES', style: SpottTextStyles.overline),
            const SizedBox(height: SpottSpacing.md),
            
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.md, vertical: SpottSpacing.sm),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: SpottColors.surface3,
                      borderRadius: BorderRadius.circular(SpottRadius.sm),
                    ),
                    child: Icon(
                      isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                      color: SpottColors.textPrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: SpottSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Dark Theme', style: SpottTextStyles.label),
                        const SizedBox(height: 2),
                        Text(
                          isDark ? 'Dark mode active' : 'Light mode active',
                          style: SpottTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isDark,
                    onChanged: (val) {
                      ride.toggleDarkMode();
                    },
                    activeColor: SpottColors.primary,
                    activeTrackColor: SpottColors.primarySoft,
                    inactiveThumbColor: SpottColors.textSecondary,
                    inactiveTrackColor: SpottColors.surface3,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: SpottSpacing.section),
            
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Log out',
                  style: SpottTextStyles.label.copyWith(color: SpottColors.danger),
                ),
              ),
            ),
            const SizedBox(height: SpottSpacing.pageBottom),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 72),
      color: SpottColors.borderSubtle,
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
          horizontal: SpottSpacing.md,
          vertical: SpottSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: SpottColors.surface3,
                borderRadius: BorderRadius.circular(SpottRadius.sm),
              ),
              child: Icon(icon, color: SpottColors.textSecondary, size: 20),
            ),
            const SizedBox(width: SpottSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: SpottTextStyles.label),
                  const SizedBox(height: 2),
                  Text(detail, style: SpottTextStyles.caption),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: SpottColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
