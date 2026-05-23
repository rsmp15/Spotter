import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../app/app_assets.dart';
import '../../app/app_routes.dart';
import '../../controllers/ride_controller.dart';
import '../../helper.dart';
import '../../models/ride_models.dart';
import '../../spotter_widgets.dart';

class SpotterFarePanel extends StatelessWidget {
  const SpotterFarePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final selectedOption = ride.selectedRideOption;
    final isDark = ride.isDarkMode;

    final fare = selectedOption?.fare ?? 0;
    final base = (fare * 0.52).round();
    final distance = (fare * 0.36).round();
    final demand = fare - base - distance;

    Widget content = Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0C0F14).withValues(alpha: 0.82)
            : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: isDark
            ? Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1.5,
              )
            : null,
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
                color: isDark ? Colors.grey[700] : Colors.grey[300],
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
                      icon: Icon(
                        Icons.arrow_back,
                        color: isDark ? Colors.white : Helper.ink,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Expanded(
                      child: Text(
                        'Price estimate',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark ? Colors.white : Helper.ink,
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
                          isDark: isDark,
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
                  color: isDark
                      ? const Color(0xFF1E293B).withValues(alpha: 0.5)
                      : Helper.cardColor,
                  padding: const EdgeInsets.all(14),
                  children: [
                    Text(
                      'Fare breakup',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InfoRow(
                      label: 'Base fare',
                      value: 'Rs $base',
                      valueColor: isDark ? Colors.grey[300]! : Helper.ink,
                    ),
                    InfoRow(
                      label: 'Distance',
                      value: 'Rs $distance',
                      valueColor: isDark ? Colors.grey[300]! : Helper.ink,
                    ),
                    InfoRow(
                      label: 'Demand',
                      value: 'Rs $demand',
                      valueColor: isDark ? Colors.grey[300]! : Helper.ink,
                    ),
                    Divider(
                      height: 16,
                      color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
                    ),
                    InfoRow(
                      label: 'Estimated total',
                      value: ride.fareLabel,
                      valueColor: isDark ? Colors.white : Colors.black,
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

    if (isDark) {
      content = ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: content,
        ),
      );
    }

    return content;
  }
}

class _VehicleSelectionCard extends StatelessWidget {
  final RideOption option;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  const _VehicleSelectionCard({
    required this.option,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final assetPath = _assetFor(option);
    final fallbackIcon = _fallbackIconFor(option);

    final cardBgColor = selected
        ? (isDark ? Colors.white : Colors.black)
        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6));

    final textColor = selected
        ? (isDark ? Colors.black : Colors.white)
        : (isDark ? Colors.white : Colors.black);

    final subTextColor = selected
        ? (isDark ? Colors.grey[800]! : Colors.grey[300]!)
        : (isDark ? Colors.grey[400]! : const Color(0xFF5E5E5E));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 110,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? (isDark ? Colors.white : Colors.black)
                : Colors.transparent,
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
                return Icon(fallbackIcon, size: 28, color: textColor);
              },
            ),
            const SizedBox(height: 8),
            Text(
              option.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              option.fareLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: subTextColor,
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
