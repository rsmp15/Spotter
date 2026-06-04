import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/app_routes.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/theme/colors.dart';
import '../core/theme/radius.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';

class SafetyToolkitScreen extends StatefulWidget {
  const SafetyToolkitScreen({super.key});

  @override
  State<SafetyToolkitScreen> createState() => _SafetyToolkitScreenState();
}

class _SafetyToolkitScreenState extends State<SafetyToolkitScreen> {
  bool _liveSharing = true;

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: SpottColors.textPrimary),
        title: const Text('Safety Center', style: SpottTextStyles.titleSmall),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.pageHorizontal),
        child: Column(
          children: [
            const SizedBox(height: SpottSpacing.lg),

            // ── Trust Badge Hero ────────────────────────────────
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: SpottColors.successSoft,
                border: Border.all(color: SpottColors.success.withValues(alpha: 0.15)),
              ),
              child: const Icon(
                Icons.shield_rounded,
                size: 40,
                color: SpottColors.success,
              ),
            ),
            const SizedBox(height: SpottSpacing.md),
            const Text('Community Safety Score', style: SpottTextStyles.caption),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('99.2%', style: SpottTextStyles.displayLarge),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: SpottColors.successSoft,
                    borderRadius: BorderRadius.circular(SpottRadius.pill),
                    border: Border.all(color: SpottColors.success.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    'EXCELLENT',
                    style: SpottTextStyles.overline.copyWith(
                      color: SpottColors.success,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: SpottSpacing.xl),

            // ── Emergency SOS Active Board ──────────────────────
            GestureDetector(
              onLongPressStart: (_) => HapticFeedback.mediumImpact(),
              onLongPress: () {
                HapticFeedback.heavyImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('SOS Activated! Dispatching emergency response team.'),
                    backgroundColor: SpottColors.danger,
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(SpottSpacing.md),
                decoration: BoxDecoration(
                  color: SpottColors.surface3,
                  borderRadius: BorderRadius.circular(SpottRadius.card),
                  border: Border.all(color: SpottColors.border),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: SpottColors.dangerSoft,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.sos_rounded, size: 28, color: SpottColors.danger),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'HOLD FOR 2 SECONDS FOR EMERGENCY SOS',
                      style: SpottTextStyles.label.copyWith(
                        color: SpottColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Notifies nearest emergency units and sends location coordinates.',
                      style: SpottTextStyles.caption.copyWith(color: SpottColors.textTertiary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: SpottColors.surface2,
                        borderRadius: BorderRadius.circular(SpottRadius.xs),
                      ),
                      child: Text(
                        'Safety Response Dispatch Time: < 2 mins',
                        style: SpottTextStyles.caption.copyWith(
                          color: SpottColors.warning,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: SpottSpacing.section),

            // ── Primary Safety Features ──────────────────────────
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'CORE SAFETY UTILITIES',
                style: SpottTextStyles.overline.copyWith(color: SpottColors.textTertiary),
              ),
            ),
            const SizedBox(height: SpottSpacing.md),

            GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  // Emergency contacts
                  _buildSafetyRow(
                    icon: Icons.contacts_rounded,
                    title: 'Trusted Contacts',
                    subtitle: '3 active contacts configured',
                    iconColor: SpottColors.accentPurple,
                    onTap: () {
                      _showMessage(context, 'Manage trusted contacts list');
                    },
                  ),
                  _buildDivider(),

                  // Live sharing toggle
                  Padding(
                    padding: const EdgeInsets.all(SpottSpacing.md),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: SpottColors.infoSoft,
                            borderRadius: BorderRadius.circular(SpottRadius.sm),
                          ),
                          child: const Icon(Icons.share_location_rounded, color: SpottColors.info, size: 20),
                        ),
                        const SizedBox(width: SpottSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Live Trip Sharing', style: SpottTextStyles.label),
                              const SizedBox(height: 2),
                              Text('Sends active GPS tracker to contacts', style: SpottTextStyles.caption),
                            ],
                          ),
                        ),
                        Switch(
                          value: _liveSharing,
                          activeColor: SpottColors.success,
                          activeTrackColor: SpottColors.successSoft,
                          inactiveThumbColor: SpottColors.textSecondary,
                          inactiveTrackColor: SpottColors.surface1,
                          onChanged: (val) {
                            setState(() => _liveSharing = val);
                            HapticFeedback.lightImpact();
                          },
                        ),
                      ],
                    ),
                  ),
                  _buildDivider(),

                  // Verification status
                  _buildSafetyRow(
                    icon: Icons.verified_rounded,
                    title: 'Verification Status',
                    subtitle: 'Aadhaar ID & Driver License verified',
                    iconColor: SpottColors.success,
                    onTap: () {
                      _showMessage(context, 'View official verification credentials');
                    },
                  ),
                  _buildDivider(),

                  // Incident report
                  _buildSafetyRow(
                    icon: Icons.report_problem_rounded,
                    title: 'Report Incident',
                    subtitle: 'Log safe-travel issues or route anomalies',
                    iconColor: SpottColors.warning,
                    onTap: () {
                      _showMessage(context, 'Report active ride issue');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: SpottSpacing.xl),

            // ── Safety Support Center ─────────────────────────────
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'SUPPORT & HOTLINES',
                style: SpottTextStyles.overline.copyWith(color: SpottColors.textTertiary),
              ),
            ),
            const SizedBox(height: SpottSpacing.md),

            GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildSafetyRow(
                    icon: Icons.phone_callback_rounded,
                    title: '24/7 Safety Hotline',
                    subtitle: 'Call SPOTT dedicated security desk',
                    iconColor: SpottColors.success,
                    onTap: () {
                      _showMessage(context, 'Initiating call to SPOTT Safety Desk');
                    },
                  ),
                  _buildDivider(),
                  _buildSafetyRow(
                    icon: Icons.support_agent_rounded,
                    title: 'Chat with Support',
                    subtitle: 'Live messenger response under 1 min',
                    iconColor: SpottColors.accentPurple,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.support),
                  ),
                ],
              ),
            ),

            const SizedBox(height: SpottSpacing.pageBottom),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(SpottSpacing.md),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(SpottRadius.sm),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: SpottSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: SpottTextStyles.label),
                  const SizedBox(height: 2),
                  Text(subtitle, style: SpottTextStyles.caption),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: SpottColors.textTertiary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 72),
      color: SpottColors.border,
    );
  }

  void _showMessage(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
