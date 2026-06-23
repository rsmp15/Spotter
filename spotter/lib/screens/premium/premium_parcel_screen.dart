import 'package:flutter/material.dart';
import '../../theme/spott_theme.dart';
import '../../widgets/premium/glassmorphism.dart';
import '../../widgets/premium/premium_button.dart';

class PremiumParcelScreen extends StatelessWidget {
  const PremiumParcelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpottTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Send a Parcel", style: SpottTheme.textTheme.titleLarge),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SpottTheme.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRouteCard(),
            const SizedBox(height: SpottTheme.spacingLarge),
            _buildParcelDetails(),
            const SizedBox(height: SpottTheme.spacingLarge),
            _buildPriceEstimate(),
            const SizedBox(height: SpottTheme.spacingXLarge),
            PremiumButton(text: "Find Delivery Partner", onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteCard() {
    return Glassmorphism(
      padding: const EdgeInsets.all(SpottTheme.spacingLarge),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.my_location, color: SpottTheme.primary),
              const SizedBox(width: SpottTheme.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pickup Location",
                      style: SpottTheme.textTheme.labelMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Kothrud, Pune",
                      style: SpottTheme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Divider(color: SpottTheme.card),
          ),
          Row(
            children: [
              const Icon(Icons.location_on, color: SpottTheme.success),
              const SizedBox(width: SpottTheme.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Drop-off Location",
                      style: SpottTheme.textTheme.labelMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Shivaji Park, Mumbai",
                      style: SpottTheme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParcelDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Parcel Details", style: SpottTheme.textTheme.titleLarge),
        const SizedBox(height: SpottTheme.spacingMedium),
        Glassmorphism(
          padding: const EdgeInsets.all(SpottTheme.spacingLarge),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Category", style: SpottTheme.textTheme.bodyLarge),
                  Text("Electronics", style: SpottTheme.textTheme.titleMedium),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: SpottTheme.card),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Weight", style: SpottTheme.textTheme.bodyLarge),
                  Text("Up to 5 kg", style: SpottTheme.textTheme.titleMedium),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: SpottTheme.card),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Dimensions", style: SpottTheme.textTheme.bodyLarge),
                  Text("Small Box", style: SpottTheme.textTheme.titleMedium),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceEstimate() {
    return Glassmorphism(
      padding: const EdgeInsets.all(SpottTheme.spacingLarge),
      color: SpottTheme.primary.withValues(alpha: 0.1),
      border: Border.all(color: SpottTheme.primary.withValues(alpha: 0.3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Estimated Price", style: SpottTheme.textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(
                "₹ 250 - ₹ 350",
                style: SpottTheme.textTheme.headlineMedium?.copyWith(
                  color: SpottTheme.primary,
                ),
              ),
            ],
          ),
          const Icon(Icons.local_offer, color: SpottTheme.primary, size: 32),
        ],
      ),
    );
  }
}

