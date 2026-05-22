import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class FareEstimateScreen extends StatelessWidget {
  const FareEstimateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final fare = ride.selectedRideOption?.fare ?? 0;
    final base = (fare * 0.52).round();
    final distance = (fare * 0.36).round();
    final demand = fare - base - distance;

    return SpotterScreen(
      title: 'Price estimate',
      subtitle: 'Fare based on route, demand and ride type.',
      content: [
        RecoveryBanner(state: ride.actionState, onRetry: ride.retryInitialize),
        RideContextCard(
          route: ride.routeLabel,
          fare: ride.fareLabel,
          driver: ride.selectedDriver?.name ?? 'Matching',
          status: ride.status.name,
        ),
        const MapPlaceholder(height: 160),
        SpotterCard(
          children: [
            const Text(
              'Fare breakup',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            InfoRow(label: 'Base fare', value: 'Rs $base'),
            InfoRow(label: 'Distance', value: 'Rs $distance'),
            InfoRow(label: 'Demand', value: 'Rs $demand'),
            const Divider(),
            InfoRow(
              label: 'Estimated total',
              value: ride.fareLabel,
              valueColor: Helper.primary,
            ),
          ],
        ),
        SpotterCard(
          children: [
            InfoRow(
              label: ride.selectedRideOption?.name ?? 'Standard',
              value:
                  ride.selectedRideOption?.detail.split(' - ').first ??
                  '2 min away',
            ),
            const InfoRow(
              label: 'Priority pickup',
              value: 'Add Rs 20',
              valueColor: Helper.warning,
            ),
          ],
        ),
      ],
      bottom: const PrimaryAction(
        label: 'Find drivers',
        routeName: AppRoutes.drivers,
      ),
    );
  }
}
