import 'package:flutter/material.dart';
import '../../theme/spott_theme.dart';
import '../../widgets/premium/trip_result_card.dart';
import 'premium_trip_details_screen.dart';
import '../../widgets/premium/glassmorphism.dart';

class PremiumTripsScreen extends StatelessWidget {
  const PremiumTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpottTheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(SpottTheme.spacingLarge),
              child: Text("Your Trips", style: SpottTheme.textTheme.displayMedium),
            ),
            _buildTabs(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  left: SpottTheme.spacingLarge,
                  right: SpottTheme.spacingLarge,
                  top: SpottTheme.spacingMedium,
                  bottom: 120, // space for nav bar
                ),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return TripResultCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PremiumTripDetailsScreen(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpottTheme.spacingLarge),
      child: Glassmorphism(
        padding: const EdgeInsets.all(4),
        borderRadius: 20,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: SpottTheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Upcoming",
                  style: SpottTheme.textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                child: Text(
                  "Past",
                  style: SpottTheme.textTheme.labelLarge?.copyWith(color: SpottTheme.textSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
