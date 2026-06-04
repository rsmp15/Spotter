import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../spotter_widgets.dart';

class TripDetailsScreen extends StatelessWidget {
  const TripDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpotterScreen(
      title: 'Trip Details',
      subtitle: 'Pune to Kolhapur with Arjun K.',
      showBack: true,
      content: [
        MapPlaceholder(height: 170),
        SpotterCard(
          children: [
            InfoRow(label: 'Driver', value: 'Arjun K.'),
            InfoRow(label: 'Vehicle', value: 'Honda City (MH12 AB1234)'),
            InfoRow(label: 'Driver rating', value: '4.9'),
            InfoRow(label: 'Cost per seat', value: 'Rs 850'),
          ],
        ),
        SpotterCard(
          children: [
            InfoRow(label: 'Available seats', value: '2 left'),
            InfoRow(label: 'Parcel allowance', value: 'Yes (up to 5kg)'),
          ],
        ),
      ],
      bottom: PrimaryAction(
        label: 'Request Seat',
        routeName: AppRoutes.confirmRide,
      ),
    );
  }
}
