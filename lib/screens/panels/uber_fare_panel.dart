import 'package:flutter/material.dart';
import '../../app/app_assets.dart';
import '../../app/app_routes.dart';
import '../../controllers/ride_controller.dart';
import '../../helper.dart';
import '../../models/ride_models.dart';
import '../../spotter_widgets.dart';

class UberFarePanel extends StatelessWidget {
  const UberFarePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final selectedOption = ride.selectedRideOption;

    final fare = selectedOption?.fare ?? 0;
    final base = (fare * 0.52).round();
    final distance = (fare * 0.36).round();
    final demand = fare - base - distance;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: Helper.premiumShadows,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4.5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.arrow_back, color: Helper.ink),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Expanded(
                      child: Text(
                        'Price estimate',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Helper.ink,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
                const SizedBox(height: 16),
                if (ride.actionState.isFailure) ...[
                  RecoveryBanner(
                    state: ride.actionState,
                    onRetry: ride.retryInitialize,
                  ),
                  const SizedBox(height: 12),
                ],
                // Vehicle Options horizontal list
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final option in ride.rideOptions) ...[
                        _VehicleSelectionCard(
                          option: option,
                          selected: selectedOption?.id == option.id,
                          onTap: () {
                            ride.selectRideOption(option);
                          },
                        ),
                        const SizedBox(width: 10),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Fare details
                SpotterCard(
                  padding: const EdgeInsets.all(14),
                  children: [
                    const Text(
                      'Fare breakup',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InfoRow(label: 'Base fare', value: 'Rs $base'),
                    InfoRow(label: 'Distance', value: 'Rs $distance'),
                    InfoRow(label: 'Demand', value: 'Rs $demand'),
                    const Divider(height: 16),
                    InfoRow(
                      label: 'Estimated total',
                      value: ride.fareLabel,
                      valueColor: Colors.black,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                PrimaryAction(
                  label: 'Find drivers',
                  onPressed: () {
                    // Update state to searching
                    ride.selectRideOption(
                      selectedOption ?? ride.rideOptions.first,
                    );
                    Navigator.pushNamed(context, AppRoutes.drivers);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleSelectionCard extends StatelessWidget {
  final RideOption option;
  final bool selected;
  final VoidCallback onTap;

  const _VehicleSelectionCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final assetPath = _assetFor(option);
    final fallbackIcon = _fallbackIconFor(option);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 110,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? Colors.black : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? Colors.black : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              assetPath,
              width: 36,
              height: 28,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  fallbackIcon,
                  size: 28,
                  color: selected ? Colors.white : Colors.black,
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              option.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              option.fareLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.grey[300] : const Color(0xFF5E5E5E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _assetFor(RideOption option) {
    switch (option.id) {
      case 'moto':
      case 'bike':
        return AppAssets.bike;
      case 'auto':
      case 'rickshaw':
      case 'rikshaw':
        return AppAssets.rikshaw;
      default:
        return AppAssets.car;
    }
  }

  IconData _fallbackIconFor(RideOption option) {
    switch (option.id) {
      case 'moto':
      case 'bike':
        return Icons.two_wheeler_rounded;
      case 'auto':
      case 'rickshaw':
      case 'rikshaw':
        return Icons.electric_rickshaw_rounded;
      case 'comfort':
        return Icons.local_taxi_rounded;
      default:
        return Icons.directions_car_filled_rounded;
    }
  }
}
