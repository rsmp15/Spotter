import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotter/design_system/design_system.dart';
import '../app/app_routes.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;
    return GlassScaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: DSSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.surfaceVariant,
                  border: Border.all(color: palette.border),
                ),
                child: Icon(
                  CupertinoIcons.settings,
                  size: 40,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: DSSpacing.xl),
              Text(
                'Scheduled Maintenance',
                textAlign: TextAlign.center,
                style: DSTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: DSSpacing.md),
              Text(
                'We are making the app faster and more reliable. Spott is undergoing upgrades. We\'ll be back shortly.',
                textAlign: TextAlign.center,
                style: DSTypography.body.copyWith(
                  color: palette.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: DSSpacing.xxl),
              SizedBox(
                width: double.infinity,
                child: SpottButton.primary(
                  label: 'Check Status',
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.splash);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


