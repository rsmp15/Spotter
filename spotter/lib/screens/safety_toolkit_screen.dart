import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


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
        title: const Text('SPOTT', style: SpottTextStyles.sectionTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.lg),
        child: Column(
          children: [
            const SizedBox(height: SpottSpacing.xl),

            // Header Hero
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: SpottColors.primary.withValues(alpha:0.05),
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: const Icon(
                Icons.shield_rounded,
                size: 64,
                color: SpottColors.primary,
              ),
            ),
            const SizedBox(height: SpottSpacing.lg),
            Text('Safety Center', style: SpottTextStyles.display.copyWith(fontSize: 40), textAlign: TextAlign.center),
            const SizedBox(height: SpottSpacing.md),
            Text(
              'Your security is our top priority. Access essential tools, manage trusted contacts, and verify your profile for a safer journey.',
              style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SpottSpacing.xxl),

            // Emergency Assistance
            Container(
              padding: const EdgeInsets.all(SpottSpacing.xl),
              decoration: BoxDecoration(
                color: SpottColors.primary.withValues(alpha:0.05),
                border: Border.all(color: SpottColors.primary.withValues(alpha:0.1)),
                borderRadius: BorderRadius.circular(SpottRadius.lg),
              ),
              child: Column(
                children: [
                  Text('Emergency Assistance', style: SpottTextStyles.headline.copyWith(color: SpottColors.primary, fontSize: 24)),
                  const SizedBox(height: SpottSpacing.sm),
                  Text(
                    'Connect immediately with local authorities or support.',
                    style: SpottTextStyles.body.copyWith(color: SpottColors.primary.withValues(alpha:0.8), fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: SpottSpacing.xl),
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
                      padding: const EdgeInsets.symmetric(vertical: SpottSpacing.lg),
                      decoration: BoxDecoration(
                        color: SpottColors.primary,
                        borderRadius: BorderRadius.circular(SpottRadius.pill),
                        boxShadow: [
                          BoxShadow(color: SpottColors.primary.withValues(alpha:0.3), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.sos_rounded, color: Colors.white, size: 24),
                          const SizedBox(width: SpottSpacing.md),
                          Text('HOLD TO SOS', style: SpottTextStyles.titleSmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SpottSpacing.xl),

            // Trip Sharing
            GlassCard(
              padding: const EdgeInsets.all(SpottSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(
                      color: SpottColors.infoSoft,
                      shape: BoxShape.circle,
                      border: Border.all(color: SpottColors.info.withValues(alpha:0.2)),
                    ),
                    child: const Icon(Icons.share_location_rounded, color: SpottColors.info, size: 28),
                  ),
                  const SizedBox(height: SpottSpacing.lg),
                  Text('Trip Sharing', style: SpottTextStyles.headline.copyWith(fontSize: 20)),
                  const SizedBox(height: SpottSpacing.sm),
                  Text(
                    'Automatically share your live location and route details with family or friends during active journeys.',
                    style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary),
                  ),
                  const SizedBox(height: SpottSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() => _liveSharing = !_liveSharing);
                          HapticFeedback.lightImpact();
                        },
                        child: Row(
                          children: [
                            Text(_liveSharing ? 'Sharing Active' : 'Configure settings', style: SpottTextStyles.label.copyWith(color: SpottColors.primary, fontWeight: FontWeight.bold)),
                            const SizedBox(width: SpottSpacing.xs),
                            const Icon(Icons.arrow_forward_rounded, color: SpottColors.primary, size: 16),
                          ],
                        ),
                      ),
                      Switch(
                        value: _liveSharing,
                        onChanged: (v) {
                          setState(() => _liveSharing = v);
                          HapticFeedback.lightImpact();
                        },
                        activeThumbColor: SpottColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: SpottSpacing.lg),

            // Trusted Contacts
            GlassCard(
              padding: const EdgeInsets.all(SpottSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(
                      color: SpottColors.accentPurple.withValues(alpha:0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: SpottColors.accentPurple.withValues(alpha:0.2)),
                    ),
                    child: const Icon(Icons.group_rounded, color: SpottColors.accentPurple, size: 28),
                  ),
                  const SizedBox(height: SpottSpacing.lg),
                  Text('Trusted Contacts', style: SpottTextStyles.headline.copyWith(fontSize: 20)),
                  const SizedBox(height: SpottSpacing.sm),
                  Text(
                    'Manage the people who receive your automated updates and SOS alerts in case of an emergency.',
                    style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary),
                  ),
                  const SizedBox(height: SpottSpacing.lg),
                  Row(
                    children: [
                      _buildAvatar('https://i.pravatar.cc/150?img=47'),
                      Transform.translate(offset: const Offset(-10, 0), child: _buildAvatar('https://i.pravatar.cc/150?img=12')),
                      Transform.translate(
                        offset: const Offset(-20, 0),
                        child: Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: SpottColors.surface1,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          alignment: Alignment.center,
                          child: Text('+2', style: SpottTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SpottSpacing.md),
                  InkWell(
                    onTap: () => _showMessage(context, 'Manage trusted contacts list'),
                    child: Row(
                      children: [
                        Text('Manage contacts', style: SpottTextStyles.label.copyWith(color: SpottColors.primary, fontWeight: FontWeight.bold)),
                        const SizedBox(width: SpottSpacing.xs),
                        const Icon(Icons.arrow_forward_rounded, color: SpottColors.primary, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SpottSpacing.lg),

            // Verification Center
            GlassCard(
              padding: const EdgeInsets.all(SpottSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(
                      color: SpottColors.primary.withValues(alpha:0.05),
                      shape: BoxShape.circle,
                      border: Border.all(color: SpottColors.primary.withValues(alpha:0.1)),
                    ),
                    child: const Icon(Icons.verified_user_rounded, color: SpottColors.primary, size: 28),
                  ),
                  const SizedBox(height: SpottSpacing.lg),
                  Text('Verification Center', style: SpottTextStyles.headline.copyWith(fontSize: 20)),
                  const SizedBox(height: SpottSpacing.sm),
                  Text(
                    'Complete your identity verification to unlock premium features and increase trust within the community.',
                    style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary),
                  ),
                  const SizedBox(height: SpottSpacing.lg),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.md, vertical: SpottSpacing.md),
                    decoration: BoxDecoration(
                      color: SpottColors.surface1,
                      borderRadius: BorderRadius.circular(SpottRadius.md),
                      border: Border.all(color: SpottColors.borderSubtle),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: SpottColors.primary, size: 20),
                            const SizedBox(width: SpottSpacing.sm),
                            Text('ID Verified', style: SpottTextStyles.label.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(SpottRadius.xs),
                          ),
                          child: Text('Level 2', style: SpottTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: SpottSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: SpottColors.textPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(SpottRadius.pill),
                          side: const BorderSide(color: SpottColors.borderSubtle),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: SpottSpacing.md),
                      ),
                      onPressed: () => _showMessage(context, 'View official verification credentials'),
                      child: Text('Review Status', style: SpottTextStyles.label.copyWith(fontWeight: FontWeight.bold)),
                    ),
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

  Widget _buildAvatar(String url) {
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }

  void _showMessage(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
