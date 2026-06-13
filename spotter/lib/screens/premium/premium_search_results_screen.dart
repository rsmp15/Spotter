import 'package:flutter/material.dart';
import '../../theme/spott_theme.dart';
import '../../widgets/premium/glassmorphism.dart';
import '../../widgets/premium/trip_result_card.dart';
import 'premium_trip_details_screen.dart';

class PremiumSearchResultsScreen extends StatelessWidget {
  const PremiumSearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpottTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildFilters(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(SpottTheme.spacingLarge),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return TripResultCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PremiumTripDetailsScreen(),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(SpottTheme.spacingLarge),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: SpottTheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: SpottTheme.spacingMedium),
          Expanded(
            child: Glassmorphism(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              borderRadius: 16,
              child: Row(
                children: [
                  const Icon(
                    Icons.my_location,
                    color: SpottTheme.textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text("Pune", style: SpottTheme.textTheme.labelLarge),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.arrow_forward,
                      color: SpottTheme.textSecondary,
                      size: 16,
                    ),
                  ),
                  Text("Kolhapur", style: SpottTheme.textTheme.labelLarge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final filters = [
      "All",
      "SUV",
      "Instant Book",
      "Women Only",
      "Pets Allowed",
    ];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: SpottTheme.spacingLarge,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? SpottTheme.primary : SpottTheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            alignment: Alignment.center,
            child: Text(
              filters[index],
              style: SpottTheme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.white : SpottTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          );
        },
      ),
    );
  }
}
