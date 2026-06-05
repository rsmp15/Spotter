import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../core/theme/radius.dart';

class KycVerificationScreen extends StatelessWidget {
  const KycVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: SpottColors.textPrimary),
        title: const Text('Verification Center', style: SpottTextStyles.sectionTitle),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(SpottSpacing.lg),
            children: [
              Text('Become Verified', style: SpottTextStyles.display.copyWith(fontSize: 32)),
              const SizedBox(height: SpottSpacing.xs),
              Text(
                'Build trust within the SPOTT community. Complete your profile to unlock premium benefits.', 
                style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary)
              ),
              const SizedBox(height: SpottSpacing.xl),

              // Trust Score
              GlassCard(
                padding: const EdgeInsets.all(SpottSpacing.xl),
                child: Column(
                  children: [
                    Text('Trust Score', style: SpottTextStyles.headline.copyWith(fontSize: 24)),
                    const SizedBox(height: SpottSpacing.xl),
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: CircularProgressIndicator(
                              value: 0.72,
                              color: SpottColors.primary,
                              backgroundColor: SpottColors.surface1,
                              strokeWidth: 8,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('72%', style: SpottTextStyles.display.copyWith(fontSize: 40)),
                              Text(
                                'VERIFIED', 
                                style: SpottTextStyles.label.copyWith(
                                  color: SpottColors.textSecondary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: SpottSpacing.lg),
                    Text(
                      'You\'re almost there! Complete the remaining steps to reach 100%.',
                      textAlign: TextAlign.center,
                      style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SpottSpacing.md),

              // Trust Benefits
              GlassCard(
                padding: const EdgeInsets.all(SpottSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.verified_rounded, color: SpottColors.primary),
                        const SizedBox(width: SpottSpacing.sm),
                        Text('Trust Benefits', style: SpottTextStyles.headline.copyWith(fontSize: 20)),
                      ],
                    ),
                    const SizedBox(height: SpottSpacing.lg),
                    _buildBenefitItem(
                      icon: Icons.trending_up_rounded,
                      title: 'More Bookings',
                      subtitle: 'Verified profiles receive up to 3x more booking requests.',
                    ),
                    const SizedBox(height: SpottSpacing.md),
                    _buildBenefitItem(
                      icon: Icons.visibility_rounded,
                      title: 'Higher Visibility',
                      subtitle: 'Stand out in search results with a prioritized ranking.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SpottSpacing.xl),

              // Verification Checklist
              Text('Verification Checklist', style: SpottTextStyles.headline.copyWith(fontSize: 20)),
              const SizedBox(height: SpottSpacing.xs),
              Text(
                'Complete these steps to verify your identity.', 
                style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary)
              ),
              const SizedBox(height: SpottSpacing.md),

              _KycTile(
                title: 'Aadhaar or PAN',
                subtitle: 'Upload a government ID.',
                status: 'Start',
                icon: Icons.badge_rounded,
                isActive: true,
                onTap: () => _showKycMessage(context, 'Aadhaar or PAN upload opened'),
              ),
              const SizedBox(height: SpottSpacing.sm),
              _KycTile(
                title: 'Selfie verification',
                subtitle: 'Take a quick selfie.',
                status: 'Pending',
                icon: Icons.face_rounded,
                isActive: false,
                onTap: () => _showKycMessage(context, 'Selfie verification opened'),
              ),
              const SizedBox(height: SpottSpacing.sm),
              _KycTile(
                title: 'Driving licence',
                subtitle: 'Upload your driving licence.',
                status: 'Required',
                icon: Icons.card_membership_rounded,
                isActive: false,
                onTap: () => _showKycMessage(context, 'Driving licence upload opened'),
              ),
              const SizedBox(height: SpottSpacing.sm),
              _KycTile(
                title: 'Vehicle document',
                subtitle: 'Registration and insurance.',
                status: 'Required',
                icon: Icons.directions_car_rounded,
                isActive: false,
                onTap: () => _showKycMessage(context, 'Vehicle document upload opened'),
              ),
              const SizedBox(height: 100),
            ],
          ),
          Positioned(
            bottom: SpottSpacing.lg,
            left: SpottSpacing.lg,
            right: SpottSpacing.lg,
            child: SpottButton.primary(
              label: 'Complete Verification',
              onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.driverHome),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem({required IconData icon, required String title, required String subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: SpottColors.surface1,
            shape: BoxShape.circle,
            border: Border.all(color: SpottColors.borderSubtle),
          ),
          child: Icon(icon, color: SpottColors.textPrimary, size: 20),
        ),
        const SizedBox(width: SpottSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: SpottTextStyles.titleSmall.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(subtitle, style: SpottTextStyles.body.copyWith(fontSize: 13, color: SpottColors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }

  void _showKycMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _KycTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _KycTile({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? Colors.white : SpottColors.surface2.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(SpottRadius.card), // matching rounded-btn (18px approx)
        border: Border.all(color: isActive ? SpottColors.primary : SpottColors.borderSubtle, width: isActive ? 2 : 1),
        boxShadow: isActive ? [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 10, offset: const Offset(0, 4))] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(SpottRadius.card),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(SpottRadius.card),
            child: Stack(
              children: [
                if (isActive)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(width: 6, color: SpottColors.primary),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      if (isActive) const SizedBox(width: 8), // space for left border
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: SpottColors.surface1,
                          shape: BoxShape.circle,
                          border: Border.all(color: SpottColors.borderSubtle),
                        ),
                        child: Icon(icon, color: SpottColors.textPrimary, size: 24),
                      ),
                      const SizedBox(width: SpottSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: SpottTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: SpottColors.textPrimary)),
                            const SizedBox(height: 2),
                            Text(subtitle, style: SpottTextStyles.body.copyWith(fontSize: 13, color: SpottColors.textSecondary)),
                          ],
                        ),
                      ),
                      if (isActive)
                        ElevatedButton(
                          onPressed: onTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SpottColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SpottRadius.pill)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                            elevation: 0,
                          ),
                          child: const Text('Start', style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      else
                        Row(
                          children: [
                            Text(status, style: SpottTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: SpottColors.textSecondary)),
                            const SizedBox(width: 8),
                            const Icon(Icons.chevron_right_rounded, color: SpottColors.textSecondary),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
