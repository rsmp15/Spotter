import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../models/ride_models.dart';
import '../spotter_widgets.dart';

class DriverMatchesScreen extends StatelessWidget {
  const DriverMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);

    return SpotterScreen(
      title: 'Driver matches',
      subtitle: 'Verified drivers already close to your route.',
      content: [
        RecoveryBanner(state: ride.actionState, onRetry: ride.retryInitialize),
        RideContextCard(
          route: ride.routeLabel,
          fare: ride.fareLabel,
          driver: ride.selectedDriver?.name ?? 'Matching',
          status: ride.status.name,
        ),
        for (var i = 0; i < ride.drivers.length; i++)
          _DriverCard(
            driver: ride.drivers[i],
            fare: ride.fareLabel,
            color: [Helper.success, Helper.primary, Helper.warning][i],
            onTap: () {
              ride.selectDriver(ride.drivers[i]);
              Navigator.pushNamed(context, AppRoutes.driverProfile);
            },
          ),
      ],
      bottom: const PrimaryAction(
        label: 'View best driver',
        routeName: AppRoutes.driverProfile,
      ),
    );
  }
}

class _DriverCard extends StatelessWidget {
  final Driver driver;
  final String fare;
  final Color color;
  final VoidCallback? onTap;

  const _DriverCard({
    required this.driver,
    required this.fare,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SpotterCard(
      onTap: onTap,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Helper.canvasSoftColor(context),
              child: Text(
                driver.name[0],
                style: TextStyle(
                  color: Helper.inkColor(context),
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${driver.vehicle} - rating ${driver.rating}',
                    style: const TextStyle(color: Helper.muted, fontSize: 13),
                  ),
                ],
              ),
            ),
            Text(
              fare,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 12),
        InfoRow(label: 'Pickup ETA', value: driver.eta),
      ],
    );
  }
}

