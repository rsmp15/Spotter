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
                  backgroundColor: Helper.canvasSoftColor(context),
                  child: Text(
                    driver.name[0],
                    style: TextStyle(
                      color: Helper.inkColor(context),
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${driver.rating} rating - ${driver.completedRides} rides',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Helper.muted, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const StatusChip(label: 'KYC verified'),
            const SizedBox(height: 14),
            InfoRow(label: 'Vehicle', value: driver.vehicle),
            const InfoRow(
              label: 'On time',
              value: '98 percent',
            ),
          ],
        ),
        const SpotterCard(
          children: [
            InfoRow(
              label: 'ID verified',
              value: 'Yes',
            ),
            InfoRow(
              label: 'Vehicle verified',
              value: 'Yes',
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
