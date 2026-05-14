import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../app/app_error_screen.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final driver =
        ride.selectedDriver ??
        (ride.drivers.isEmpty ? null : ride.drivers.first);

    if (driver == null) {
      return const AppErrorScreen(
        title: 'No driver selected',
        message: 'Go back and choose an available driver to continue.',
      );
    }

    return SpotterScreen(
      title: 'Driver profile',
      subtitle: 'Verified route partner.',
      content: [
        SpotterCard(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFFEAFBF4),
                  child: Text(
                    driver.name[0],
                    style: const TextStyle(
                      color: Helper.success,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${driver.rating} rating - ${driver.completedRides} rides',
                      style: const TextStyle(color: Helper.muted),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const StatusChip(label: 'KYC verified', color: Helper.success),
            const SizedBox(height: 14),
            InfoRow(label: 'Vehicle', value: driver.vehicle),
            const InfoRow(
              label: 'On time',
              value: '98 percent',
              valueColor: Helper.success,
            ),
          ],
        ),
        const SpotterCard(
          children: [
            InfoRow(
              label: 'ID verified',
              value: 'Yes',
              valueColor: Helper.success,
            ),
            InfoRow(
              label: 'Vehicle verified',
              value: 'Yes',
              valueColor: Helper.success,
            ),
            InfoRow(label: 'Cancel rate', value: '2 percent'),
          ],
        ),
      ],
      bottom: const PrimaryAction(
        label: 'Choose driver',
        routeName: AppRoutes.confirmRide,
      ),
    );
  }
}
