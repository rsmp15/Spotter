import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../app/app_routes.dart';
import '../../controllers/ride_controller.dart';
import '../../helper.dart';
import '../../models/ride_models.dart';
import '../../spotter_widgets.dart';

import 'package:spotter/design_system/design_system.dart';

class SpotterTrackingPanel extends StatelessWidget {
  const SpotterTrackingPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final driver =
        ride.selectedDriver ??
        (ride.drivers.isNotEmpty ? ride.drivers.first : null);
    final isDark = ride.isDarkMode;

    Widget content = Container(
      decoration: BoxDecoration(
        color: isDark
            ? DSColors.surfaceVariant.withValues(alpha: 0.95)
            : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: isDark
            ? Border.all(
                color: DSColors.border,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Live tracking',
                      style: TextStyle(
                        color: isDark ? Colors.white : DSColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    StatusChip(
                      label: ride.status == TripStatus.arriving
                          ? 'Arriving soon'
                          : 'In progress',
                      color: isDark ? const Color(0xFF38BDF8) : Colors.black,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (ride.actionState.isFailure) ...[
                  RecoveryBanner(
                    state: ride.actionState,
                    onRetry: ride.retryInitialize,
                  ),
                  const SizedBox(height: 12),
                ],
                // Active Driver particulars card
                if (driver != null)
                  SpotterCard(
                    color: isDark
                        ? const Color(0xFF1E293B).withValues(alpha: 0.5)
                        : Helper.cardColor,
                    padding: const EdgeInsets.all(14),
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: isDark
                                ? const Color(0xFF1E293B)
                                : Colors.grey[200],
                            child: Text(
                              driver.name[0],
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  driver.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                                Text(
                                  '${driver.vehicle} â€¢ â˜… ${driver.rating}',
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Helper.muted,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              driver.eta,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                // Trip Context Row
                _ResponsiveRideContextCard(
                  route: ride.routeLabel,
                  fare: ride.fareLabel,
                  driver: driver?.name ?? 'Matching',
                  status: ride.status.name,
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                
                // Prominent Safety Toolkit & SOS button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DSColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.safetyToolkit);
                    },
                    icon: const Icon(Icons.shield_rounded, size: 18),
                    label: const Text(
                      'Safety Toolkit & SOS',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Quick actions grid
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          side: BorderSide(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : const Color(0xFFE2E8F0),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.chat),
                        icon: Icon(
                          Icons.chat_bubble_rounded,
                          size: 16,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        label: Text(
                          'Chat',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          side: BorderSide(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : const Color(0xFFE2E8F0),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.support),
                        icon: Icon(
                          Icons.help_outline_rounded,
                          size: 16,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        label: Text(
                          'Support',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          side: BorderSide(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : const Color(0xFFE2E8F0),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.shareTrip),
                        icon: Icon(
                          Icons.share_rounded,
                          size: 16,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        label: Text(
                          'Share',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          side: BorderSide(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : const Color(0xFFE2E8F0),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.cancelRide),
                        icon: const Icon(
                          Icons.cancel_outlined,
                          size: 16,
                          color: Colors.red,
                        ),
                        label: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                PrimaryAction(
                  label: 'Show ride OTP',
                  routeName: AppRoutes.rideOtp,
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

class _ResponsiveRideContextCard extends StatelessWidget {
  final String route;
  final String fare;
  final String driver;
  final String status;
  final bool isDark;

  const _ResponsiveRideContextCard({
    required this.route,
    required this.fare,
    required this.driver,
    required this.status,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SpotterCard(
      color: isDark
          ? const Color(0xFF1E293B).withValues(alpha: 0.5)
          : const Color(0xFFF8FAFC),
      children: [
        StatusChip(
          label: 'Trip context',
          color: isDark ? const Color(0xFF38BDF8) : Helper.primary,
        ),
        const SizedBox(height: 12),
        InfoRow(
          label: 'Route',
          value: route,
          valueColor: isDark ? Colors.white : DSColors.textPrimary,
        ),
        InfoRow(
          label: 'Fare',
          value: fare,
          valueColor: isDark ? const Color(0xFF38BDF8) : DSColors.primary,
        ),
        InfoRow(
          label: 'Driver',
          value: driver,
          valueColor: isDark ? Colors.white : DSColors.textPrimary,
        ),
        InfoRow(
          label: 'Status',
          value: status,
          valueColor: isDark ? Colors.white : DSColors.textPrimary,
        ),
      ],
    );
  }
}
