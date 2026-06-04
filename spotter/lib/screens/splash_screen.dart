import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../core/theme/spacing.dart';
import '../core/components/spott_buttons.dart';
import '../core/components/status_chip.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              SpottColors.background,
              Color(0xFF150A26), // Deep violet gradient
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.lg, vertical: SpottSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Animated Radial Glow Behind Logo
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            SpottColors.primary.withValues(alpha: 0.25),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'SPOTT',
                      style: SpottTextStyles.display.copyWith(
                        fontSize: 56,
                        letterSpacing: -3.0,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Tagline
              const Text(
                'Travel Together.\nSend Smarter.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  height: 1.2,
                  fontWeight: FontWeight.bold,
                  color: SpottColors.textPrimary,
                  fontFamily: 'Inter',
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: SpottSpacing.md),

              // Feature chips row
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatusChip(label: '⚡ Cost Sharing'),
                  SizedBox(width: SpottSpacing.sm),
                  StatusChip(label: '📦 Parcel Delivery'),
                  SizedBox(width: SpottSpacing.sm),
                  StatusChip(label: '🛡 Verified'),
                ],
              ),

              const Spacer(),

              // Primary Get Started CTA Button
              SpottButton.primary(
                label: 'Get Started',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.chooseRole);
                },
              ),
              const SizedBox(height: SpottSpacing.md),

              // Ghost Secondary Button
              SpottButton.ghost(
                label: 'I already have an account',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
              ),
              const SizedBox(height: SpottSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
