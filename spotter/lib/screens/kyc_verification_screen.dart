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
        title: const Text('Complete KYC', style: SpottTextStyles.sectionTitle),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(SpottSpacing.lg),
            children: [
              Text('Required before accepting trip requests.', style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary)),
              const SizedBox(height: SpottSpacing.xl),

              GlassCard(
                padding: const EdgeInsets.all(SpottSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Verification progress', style: SpottTextStyles.sectionTitle),
                    const SizedBox(height: SpottSpacing.md),
                    LinearProgressIndicator(
                      value: 0.35,
                      color: SpottColors.primary,
                      backgroundColor: SpottColors.surface1,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(SpottRadius.pill),
                    ),
                    const SizedBox(height: SpottSpacing.sm),
                    Text('35 percent completed', style: SpottTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: SpottColors.textPrimary)),
                  ],
                ),
              ),
              const SizedBox(height: SpottSpacing.md),

              _KycTile(
                title: 'Aadhaar or PAN',
                status: 'Pending',
                onTap: () => _showKycMessage(context, 'Aadhaar or PAN upload opened'),
              ),
              const SizedBox(height: SpottSpacing.sm),
              _KycTile(
                title: 'Selfie verification',
                status: 'Pending',
                onTap: () => _showKycMessage(context, 'Selfie verification opened'),
              ),
              const SizedBox(height: SpottSpacing.sm),
              _KycTile(
                title: 'Driving licence',
                status: 'Required',
                onTap: () => _showKycMessage(context, 'Driving licence upload opened'),
              ),
              const SizedBox(height: SpottSpacing.sm),
              _KycTile(
                title: 'Vehicle document',
                status: 'Required',
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
              label: 'Continue demo',
              onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.driverHome),
            ),
          ),
        ],
      ),
    );
  }

  void _showKycMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _KycTile extends StatelessWidget {
  final String title;
  final String status;
  final VoidCallback onTap;

  const _KycTile({
    required this.title,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.lg, vertical: SpottSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: SpottTextStyles.body.copyWith(fontWeight: FontWeight.w500, color: SpottColors.textPrimary)),
          ),
          Text(status, style: SpottTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: SpottColors.primary)),
          const SizedBox(width: SpottSpacing.sm),
          const Icon(Icons.chevron_right_rounded, color: SpottColors.textSecondary),
        ],
      ),
    );
  }
}
