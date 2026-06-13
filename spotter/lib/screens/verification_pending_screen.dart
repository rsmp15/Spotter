import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';
import '../controllers/ride_controller.dart';




class VerificationPendingScreen extends StatelessWidget {
  const VerificationPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: DSColors.textPrimary),
        title: Text('Verification Pending', style: DSTypography.headline),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(DSSpacing.lg),
        child: Column(
          children: [
            Text(
              'Our compliance team is verifying your documents (ETA 12 min).',
              style: DSTypography.body.copyWith(color: DSColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DSSpacing.xl * 2),

            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: DSColors.warning.withValues(alpha: 0.1),
                  border: Border.all(color: DSColors.warning.withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: DSColors.warning.withValues(alpha: 0.2),
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
            const SizedBox(height: DSSpacing.xl * 2),

            GlassCard(
              padding: const EdgeInsets.all(DSSpacing.xl),
              child: Column(
                children: [
                  Text(
                    'We are reviewing your ID and vehicle details.',
                    style: DSTypography.headline,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: DSSpacing.md),
                  Text(
                    'Please wait for the notification to start offering trips.',
                    style: DSTypography.body.copyWith(color: DSColors.textSecondary),
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
            const SizedBox(height: DSSpacing.md),
            SpottButton.secondary(
              label: 'Mock Approve (Admin)',
              onPressed: () {
                RideScope.of(context).approveKyc();
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              },
            ),
            const SizedBox(height: DSSpacing.lg),
          ],
        ),
      ),
    );
  }
}
