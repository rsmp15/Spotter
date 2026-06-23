import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';
import '../controllers/ride_controller.dart';





class KycVerificationScreen extends StatelessWidget {
  const KycVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: DSColors.textPrimary),
        title: Text('Verification Center', style: DSTypography.headline),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(DSSpacing.lg),
            children: [
              Text('Become Verified', style: DSTypography.headline.copyWith(fontSize: 32)),
              const SizedBox(height: DSSpacing.xs),
              Text(
                'Build trust within the SPOTT community. Complete your profile to unlock premium benefits.', 
                style: DSTypography.body.copyWith(color: DSColors.textSecondary)
              ),
              const SizedBox(height: DSSpacing.xl),

              // Trust Score
              GlassCard(
                padding: const EdgeInsets.all(DSSpacing.xl),
                child: Column(
                  children: [
                    Text('Trust Score', style: DSTypography.headline.copyWith(fontSize: 24)),
                    const SizedBox(height: DSSpacing.xl),
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
                              color: DSColors.primary,
                              backgroundColor: DSColors.surface,
                              strokeWidth: 8,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('72%', style: DSTypography.headline.copyWith(fontSize: 40)),
                              Text(
                                'VERIFIED', 
                                style: DSTypography.labelLarge.copyWith(
                                  color: DSColors.textSecondary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: DSSpacing.lg),
                    Text(
                      'You\'re almost there! Complete the remaining steps to reach 100%.',
                      textAlign: TextAlign.center,
                      style: DSTypography.body.copyWith(color: DSColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: DSSpacing.md),

              // Trust Benefits
              GlassCard(
                padding: const EdgeInsets.all(DSSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.verified_rounded, color: DSColors.primary),
                        const SizedBox(width: DSSpacing.sm),
                        Text('Trust Benefits', style: DSTypography.headline.copyWith(fontSize: 20)),
                      ],
                    ),
                    const SizedBox(height: DSSpacing.lg),
                    _buildBenefitItem(
                      icon: Icons.trending_up_rounded,
                      title: 'More Bookings',
                      subtitle: 'Verified profiles receive up to 3x more booking requests.',
                    ),
                    const SizedBox(height: DSSpacing.md),
                    _buildBenefitItem(
                      icon: Icons.visibility_rounded,
                      title: 'Higher Visibility',
                      subtitle: 'Stand out in search results with a prioritized ranking.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: DSSpacing.xl),

              // Verification Checklist
              Text('Verification Checklist', style: DSTypography.headline.copyWith(fontSize: 20)),
              const SizedBox(height: DSSpacing.xs),
              Text(
                'Complete these steps to verify your identity.', 
                style: DSTypography.body.copyWith(color: DSColors.textSecondary)
              ),
              const SizedBox(height: DSSpacing.md),

              _KycTile(
                title: 'Aadhaar or PAN',
                subtitle: 'Upload a government ID.',
                status: 'Start',
                icon: Icons.badge_rounded,
                isActive: true,
                onTap: () => _showKycMessage(context, 'Aadhaar or PAN upload opened'),
              ),
              const SizedBox(height: DSSpacing.sm),
              _KycTile(
                title: 'Selfie verification',
                subtitle: 'Take a quick selfie.',
                status: 'Pending',
                icon: Icons.face_rounded,
                isActive: false,
                onTap: () => _showKycMessage(context, 'Selfie verification opened'),
              ),
              const SizedBox(height: DSSpacing.sm),
              _KycTile(
                title: 'Driving licence',
                subtitle: 'Upload your driving licence.',
                status: 'Required',
                icon: Icons.card_membership_rounded,
                isActive: false,
                onTap: () => _showKycMessage(context, 'Driving licence upload opened'),
              ),
              const SizedBox(height: DSSpacing.sm),
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
            bottom: DSSpacing.lg,
            left: DSSpacing.lg,
            right: DSSpacing.lg,
            child: SpottButton.primary(
              label: 'Complete Verification',
              onPressed: () {
                RideScope.of(context).submitKyc();
                Navigator.pushReplacementNamed(context, AppRoutes.verificationPending);
              },
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
            color: DSColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: DSColors.borderSubtle),
          ),
          child: Icon(icon, color: DSColors.textPrimary, size: 20),
        ),
        const SizedBox(width: DSSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: DSTypography.titleLarge.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(subtitle, style: DSTypography.body.copyWith(fontSize: 13, color: DSColors.textSecondary)),
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
        color: isActive ? Colors.white : DSColors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(DSRadius.card), // matching rounded-btn (18px approx)
        border: Border.all(color: isActive ? DSColors.primary : DSColors.borderSubtle, width: isActive ? 2 : 1),
        boxShadow: isActive ? [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 10, offset: const Offset(0, 4))] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DSRadius.card),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(DSRadius.card),
            child: Stack(
              children: [
                if (isActive)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(width: 6, color: DSColors.primary),
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
                          color: DSColors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: DSColors.borderSubtle),
                        ),
                        child: Icon(icon, color: DSColors.textPrimary, size: 24),
                      ),
                      const SizedBox(width: DSSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: DSTypography.body.copyWith(fontWeight: FontWeight.bold, color: DSColors.textPrimary)),
                            const SizedBox(height: 2),
                            Text(subtitle, style: DSTypography.body.copyWith(fontSize: 13, color: DSColors.textSecondary)),
                          ],
                        ),
                      ),
                      if (isActive)
                        ElevatedButton(
                          onPressed: onTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DSColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(80, 36),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DSRadius.pill)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                            elevation: 0,
                          ),
                          child: const Text('Start', style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      else
                        Row(
                          children: [
                            Text(status, style: DSTypography.body.copyWith(fontWeight: FontWeight.bold, color: DSColors.textSecondary)),
                            const SizedBox(width: 8),
                            const Icon(Icons.chevron_right_rounded, color: DSColors.textSecondary),
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

