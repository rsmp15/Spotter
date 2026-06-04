import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';

class VerificationPendingScreen extends StatelessWidget {
  const VerificationPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: SpottColors.textPrimary),
        title: const Text('Verification Pending', style: SpottTextStyles.sectionTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(SpottSpacing.lg),
        child: Column(
          children: [
            Text(
              'Our compliance team is verifying your documents (ETA 12 min).',
              style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SpottSpacing.xl * 2),

            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: SpottColors.warning.withValues(alpha: 0.1),
                  border: Border.all(color: SpottColors.warning.withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: SpottColors.warning.withValues(alpha: 0.2),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('⏳', style: TextStyle(fontSize: 64)),
                ),
              ),
            ),
            const SizedBox(height: SpottSpacing.xl * 2),

            GlassCard(
              padding: const EdgeInsets.all(SpottSpacing.xl),
              child: Column(
                children: [
                  Text(
                    'We are reviewing your ID and vehicle details.',
                    style: SpottTextStyles.sectionTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: SpottSpacing.md),
                  Text(
                    'Please wait for the notification to start offering trips.',
                    style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const Spacer(),
            SpottButton.primary(
              label: 'Refresh Status',
              onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.home),
            ),
            const SizedBox(height: SpottSpacing.lg),
          ],
        ),
      ),
    );
  }
}
