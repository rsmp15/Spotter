import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotter/design_system/design_system.dart';
import '../app/app_routes.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';

class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      ),
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
                  CupertinoIcons.wifi_exclamationmark,
                  size: 40,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: DSSpacing.xl),
              Text(
                'Connection Lost',
                textAlign: TextAlign.center,
                style: DSTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: DSSpacing.md),
              Text(
                'Please check your network and try again. Ensure your device is connected to Wi-Fi or cellular data.',
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
                  label: 'Retry',
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
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


