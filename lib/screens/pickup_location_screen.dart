import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../spotter_widgets.dart';
import '../white_text_field.dart';

class PickupLocationScreen extends StatelessWidget {
  const PickupLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpotterScreen(
      title: 'Pickup location',
      subtitle: 'Confirm where your driver should meet you.',
      content: [
        MapPlaceholder(height: 165),
        WhiteTextField(
          labelText: 'Pickup',
          hintText: 'Current location, Baner',
        ),
        SizedBox(height: 14),
        WhiteTextField(labelText: 'Landmark', hintText: 'Near main gate'),
        SizedBox(height: 14),
        SpotterCard(
          children: [
            InfoRow(label: 'Pickup time', value: 'Now'),
            InfoRow(label: 'Contact privacy', value: 'Number masked'),
            InfoRow(label: 'Walk distance', value: '120 m'),
          ],
        ),
      ],
      bottom: PrimaryAction(
        label: 'Choose destination',
        routeName: AppRoutes.destination,
      ),
    );
  }
}
