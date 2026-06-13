import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import '../app/app_routes.dart';




import '../core/components/spott_buttons.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DSColors.background,
      body: Column(
        children: [
          // Full-bleed Top Hero Section with subtle premium gradient
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [DSColors.surface, DSColors.background],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SPOTT',
                      style: DSTypography.headline.copyWith(
                        fontWeight: FontWeight.w900,
                        color: DSColors.primary,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Share your journey\nwith Spott',
                      style: DSTypography.displayLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: DSColors.textPrimary,
                        height: 1.15,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Scrollable Content area
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      
                      // Premium Card surface (replacing route painter placeholder)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: DSColors.surface,
                          borderRadius: BorderRadius.circular(DSRadius.card),
                          boxShadow: DSShadows.elevation1,
                          border: Border.all(color: DSColors.border),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 18,
                                      backgroundColor: DSColors.primarySoft,
                                      child: Icon(Icons.person_rounded, color: DSColors.primary, size: 18),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Arjun K.',
                                          style: DSTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '4.9 ★ Verified Driver',
                                          style: DSTypography.caption.copyWith(color: DSColors.success),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  '₹450',
                                  style: DSTypography.titleLarge.copyWith(
                                    color: DSColors.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(color: DSColors.divider),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    const Icon(Icons.radio_button_checked_rounded, color: DSColors.success, size: 16),
                                    Container(width: 1.5, height: 24, color: DSColors.border),
                                    const Icon(Icons.location_on_rounded, color: DSColors.primary, size: 16),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pune',
                                        style: DSTypography.body.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: DSColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      Text(
                                        'Mumbai',
                                        style: DSTypography.body.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: DSColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      Text(
                        "Reduce travel costs by sharing seats on trips you're already making.",
                        style: DSTypography.bodyLarge.copyWith(
                          color: DSColors.textSecondary,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Feature list inside elevated container
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: DSColors.surface,
                          borderRadius: BorderRadius.circular(DSRadius.card),
                          boxShadow: DSShadows.elevation1,
                          border: Border.all(color: DSColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFeatureRow(Icons.search_rounded, 'Search intercity trips at a fraction of the cost'),
                            const SizedBox(height: 16),
                            _buildFeatureRow(Icons.verified_user_rounded, 'Find route matches with verified co-travelers'),
                            const SizedBox(height: 16),
                            _buildFeatureRow(Icons.local_shipping_rounded, 'Send parcels same-day through travelers'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Sticky CTA inside bottom safe area
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: SpottButton.primary(
                  label: 'Get Started',
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.login);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: DSColors.primary, size: 22),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: DSTypography.body.copyWith(
              color: DSColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
