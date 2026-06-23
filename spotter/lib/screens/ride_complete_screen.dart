import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotter/design_system/design_system.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';

class RideCompleteScreen extends StatelessWidget {
  const RideCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;

    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.arrow_left,
            color: palette.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Receipt',
          style: DSTypography.headline.copyWith(
            color: palette.textPrimary,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: DSSpacing.xl),
            // Success Checkmark Container
            Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.border,
                ),
                child: Center(
                  child: Icon(
                    CupertinoIcons.checkmark_alt,
                    color: palette.textPrimary,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Ride complete',
              style: DSTypography.headline.copyWith(
                fontWeight: FontWeight.w800,
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Thanks for riding with SPOTT.',
              style: DSTypography.body.copyWith(
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(DSSpacing.md),
              decoration: BoxDecoration(
                color: palette.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: palette.border),
              ),
              child: Column(
                children: [
                  _InfoRow(label: 'Ride ID', value: 'SPT2049'),
                  Divider(height: 20, color: palette.border),
                  _InfoRow(
                    label: 'Paid',
                    value: ride.fareLabel,
                    valueColor: palette.textPrimary,
                  ),
                  Divider(height: 20, color: palette.border),
                  const _InfoRow(label: 'Completed at', value: '1:08 PM'),
                  Divider(height: 20, color: palette.border),
                  _InfoRow(
                    label: 'Driver',
                    value: ride.selectedDriver?.name ?? 'Amit Sharma',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SpottButton.primary(
            label: 'Rate driver',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.rating);
            },
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: DSTypography.body.copyWith(
            color: palette.textSecondary,
            fontFamily: 'Inter',
          ),
        ),
        Text(
          value,
          style: DSTypography.body.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor ?? palette.textPrimary,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}


