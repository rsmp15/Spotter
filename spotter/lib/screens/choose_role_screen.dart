import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../helper.dart';
import '../models/spott_models.dart';
import '../spotter_widgets.dart';
import '../controllers/ride_controller.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);

    return SpotterScreen(
      title: 'Choose role',
      subtitle: 'Travel with Spott or share your trip.',
      content: [
        SpotterCard(
          onTap: () {
            ride.updateUserRole(UserRole.passenger);
            Navigator.pushNamed(context, AppRoutes.home);
          },
          children: const [
            StatusChip(label: 'Passenger'),
            SizedBox(height: 12),
            Text(
              'Find trips',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Search intercity trips and travel at a fraction of the cost.',
              style: TextStyle(color: Helper.muted),
            ),
          ],
        ),
        SpotterCard(
          onTap: () {
            ride.updateUserRole(UserRole.traveler);
            Navigator.pushNamed(context, AppRoutes.kyc);
          },
          children: const [
            StatusChip(label: 'Traveler', color: Helper.success),
            SizedBox(height: 12),
            Text(
              'Share your trip',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Offer seats on trips you\'re already making and earn.',
              style: TextStyle(color: Helper.muted),
            ),
          ],
        ),
        SpotterCard(
          onTap: () {
            ride.updateUserRole(UserRole.parcelSender);
            Navigator.pushNamed(context, AppRoutes.home);
          },
          children: const [
            StatusChip(label: 'Parcel Sender', color: Color(0xFF6366F1)),
            SizedBox(height: 12),
            Text(
              'Send a Package',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Get same-day delivery via verified travelers heading your way.',
              style: TextStyle(color: Helper.muted),
            ),
          ],
        ),
      ],
    );
  }
}
