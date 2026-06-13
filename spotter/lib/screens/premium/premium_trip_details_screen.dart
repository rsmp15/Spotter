import 'package:flutter/material.dart';
import '../../theme/spott_theme.dart';
import '../../widgets/premium/glassmorphism.dart';
import '../../widgets/premium/premium_button.dart';
import '../../widgets/premium/trust_badge.dart';

class PremiumTripDetailsScreen extends StatelessWidget {
  const PremiumTripDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpottTheme.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMapHeader(context),
                _buildRouteInfo(),
                _buildDriverSection(),
                _buildVehicleDetails(),
                _buildBookingRules(),
              ],
            ),
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildMapHeader(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          'https://picsum.photos/seed/map/800/600',
          height: 300,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          height: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                SpottTheme.background.withValues(alpha: 0.4),
                Colors.transparent,
                SpottTheme.background,
              ],
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Glassmorphism(
              borderRadius: 24,
              padding: const EdgeInsets.all(12),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRouteInfo() {
    return Padding(
      padding: const EdgeInsets.all(SpottTheme.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today, 10:30 AM",
                style: SpottTheme.textTheme.headlineMedium,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: SpottTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: SpottTheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  "₹ 450",
                  style: SpottTheme.textTheme.titleLarge?.copyWith(
                    color: SpottTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SpottTheme.spacingLarge),
          Glassmorphism(
            padding: const EdgeInsets.all(SpottTheme.spacingMedium),
            child: Row(
              children: [
                Column(
                  children: [
                    const Icon(
                      Icons.circle,
                      size: 12,
                      color: SpottTheme.primary,
                    ),
                    Container(height: 30, width: 2, color: SpottTheme.card),
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: SpottTheme.success,
                    ),
                  ],
                ),
                const SizedBox(width: SpottTheme.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pune (Swargate)",
                        style: SpottTheme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        "Kolhapur (CBS)",
                        style: SpottTheme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpottTheme.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Your Driver", style: SpottTheme.textTheme.titleLarge),
          const SizedBox(height: SpottTheme.spacingMedium),
          Glassmorphism(
            padding: const EdgeInsets.all(SpottTheme.spacingMedium),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?u=a042581f4e29026704d',
                      ),
                    ),
                    const SizedBox(width: SpottTheme.spacingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rohan M.",
                            style: SpottTheme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: SpottTheme.warning,
                                size: 16,
                              ),
                              Text(
                                " 4.9 ",
                                style: SpottTheme.textTheme.labelLarge,
                              ),
                              Text(
                                "(120 trips)",
                                style: SpottTheme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: SpottTheme.textSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: SpottTheme.spacingMedium),
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    TrustBadge(label: "Aadhaar Verified"),
                    TrustBadge(label: "DL Verified", icon: Icons.badge),
                    TrustBadge(label: "Corporate", icon: Icons.business),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleDetails() {
    return Padding(
      padding: const EdgeInsets.all(SpottTheme.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Vehicle", style: SpottTheme.textTheme.titleLarge),
          const SizedBox(height: SpottTheme.spacingMedium),
          Glassmorphism(
            padding: const EdgeInsets.all(SpottTheme.spacingMedium),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    color: SpottTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://picsum.photos/seed/car/200/150',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: SpottTheme.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hyundai Creta",
                        style: SpottTheme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "White • MH 12 AB 1234",
                        style: SpottTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingRules() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpottTheme.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Trip Guidelines", style: SpottTheme.textTheme.titleLarge),
          const SizedBox(height: SpottTheme.spacingMedium),
          _buildRuleRow(Icons.luggage, "Max 1 medium bag per passenger"),
          _buildRuleRow(Icons.pets, "Pets are not allowed"),
          _buildRuleRow(Icons.smoke_free, "No smoking inside the vehicle"),
          _buildRuleRow(
            Icons.local_shipping,
            "Driver accepts parcels for this trip",
          ),
        ],
      ),
    );
  }

  Widget _buildRuleRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: SpottTheme.textSecondary, size: 20),
          const SizedBox(width: 12),
          Text(text, style: SpottTheme.textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Glassmorphism(
        borderRadius: 0,
        padding: const EdgeInsets.all(SpottTheme.spacingLarge),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Price", style: SpottTheme.textTheme.bodyMedium),
                    Text("₹ 450", style: SpottTheme.textTheme.headlineMedium),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: PremiumButton(text: "Request to Book", onPressed: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
