import 'package:flutter/material.dart';
import '../../theme/spott_theme.dart';
import '../../widgets/premium/glassmorphism.dart';
import 'premium_parcel_screen.dart';

class PremiumCreateScreen extends StatelessWidget {
  const PremiumCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpottTheme.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: SpottTheme.spacingLarge,
            right: SpottTheme.spacingLarge,
            top: SpottTheme.spacingLarge,
            bottom: 120, // space for nav bar
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Create", style: SpottTheme.textTheme.displayMedium),
              const SizedBox(height: SpottTheme.spacingSmall),
              Text(
                "What would you like to do today?",
                style: SpottTheme.textTheme.bodyLarge,
              ),
              const SizedBox(height: SpottTheme.spacingXLarge),
              _buildActionCard(
                context: context,
                title: "Offer a Ride",
                subtitle: "Share your journey and split costs",
                icon: Icons.directions_car,
                gradient: SpottTheme.primaryGradient,
                onTap: () {},
              ),
              const SizedBox(height: SpottTheme.spacingMedium),
              _buildActionCard(
                context: context,
                title: "Send a Parcel",
                subtitle: "Fast and secure delivery by trusted travelers",
                icon: Icons.local_shipping,
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PremiumParcelScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: SpottTheme.spacingMedium),
              Row(
                children: [
                  Expanded(
                    child: _buildSmallActionCard(
                      context: context,
                      title: "Create Event",
                      icon: Icons.event,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: SpottTheme.spacingMedium),
                  Expanded(
                    child: _buildSmallActionCard(
                      context: context,
                      title: "Sell Item",
                      icon: Icons.storefront,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(SpottTheme.spacingLarge),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: SpottTheme.borderRadiusLarge,
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: SpottTheme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: SpottTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: SpottTheme.spacingMedium),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallActionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Glassmorphism(
        padding: const EdgeInsets.all(SpottTheme.spacingLarge),
        borderRadius: SpottTheme.radiusLarge,
        child: Column(
          children: [
            Icon(icon, color: SpottTheme.textPrimary, size: 32),
            const SizedBox(height: 16),
            Text(title, style: SpottTheme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
