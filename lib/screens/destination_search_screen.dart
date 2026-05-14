import 'package:flutter/material.dart';
import 'package:spotter/app/app_routes.dart';
import 'package:spotter/controllers/ride_controller.dart';
import 'package:spotter/spotter_widgets.dart';

class DestinationSearchScreen extends StatelessWidget {
  const DestinationSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);

    return SpotterScreen(
      title: 'Choose your ride',
      subtitle: '${ride.routeLabel} - 3.2 km',
      content: [
        const MapPlaceholder(height: 180),
        for (final option in ride.rideOptions)
          RideTile(
            icon: switch (option.id) {
              'bike' => Icons.bike_scooter,
              'cab' => Icons.local_taxi,
              _ => Icons.electric_rickshaw,
            },
            title: option.name,
            detail: option.detail,
            price: option.fareLabel,
            onTap: () {
              ride.selectRideOption(option);
              Navigator.pushNamed(context, AppRoutes.fare);
            },
          ),
      ],
      bottom: PrimaryAction(
        label: 'Continue with ${ride.selectedRideOption?.name ?? 'ride'}',
        routeName: AppRoutes.fare,
      ),
    );
  }
}
