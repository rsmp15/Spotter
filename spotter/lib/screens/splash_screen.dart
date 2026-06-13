import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import '../app/app_routes.dart';



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
              DSColors.background,
              Color(0xFF150A26), // Deep violet gradient
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: DSSpacing.lg, vertical: DSSpacing.lg),
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
                            DSColors.primary.withValues(alpha: 0.25),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'SPOTT',
                      style: DSTypography.headline.copyWith(
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
                  color: DSColors.textPrimary,
                  fontFamily: 'Inter',
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: DSSpacing.md),

              // Feature chips row
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatusChip(label: '⚡ Cost Sharing'),
                  SizedBox(width: DSSpacing.sm),
                  StatusChip(label: '📦 Parcel Delivery'),
                  SizedBox(width: DSSpacing.sm),
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
              const SizedBox(height: DSSpacing.md),

              // Ghost Secondary Button
              SpottButton.ghost(
                label: 'I already have an account',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
              ),
              const SizedBox(height: DSSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
