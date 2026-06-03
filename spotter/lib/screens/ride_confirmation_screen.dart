import 'package:flutter/material.dart';

import '../app/app_assets.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class RideConfirmationScreen extends StatelessWidget {
  const RideConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;
    final scaffoldBg = isDark ? Helper.darkBackground : Helper.backgroundColor;
    final textColor = isDark ? Colors.white : Helper.ink;
    final subtitleColor = isDark ? const Color(0xFFB8B8B8) : Helper.muted;
    final cardBg = isDark ? const Color(0xFF121212) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Helper.lineColor;
    final vehicleAsset = AppAssets.forVehicleText(
      ride.selectedDriver?.vehicle ?? 'car',
    );

    final String avatarUrl =
        "https://lh3.googleusercontent.com/aida-public/AB6AXuC1KgNXZIEvPQk4lItOTANZUgEHjyoedgMru7GYC7o3nrZsTVYBp82i2l6KCb7SlUqM10tP8Xw1-mz8gJpK84DoB4JeCFt_-TzvF1QTS4HN7QyeOMMGoTr61Ro39qRFgsIlA-eS2eVf0lTMzDUxJ1IhVccZaK8dLKufd4fb4gBHnVwVBTd7ITE4cOtqHGAItS4zJOVacaBInEWLW66_5ZHzAGKqKrMM6q2DBvn-n4vJIwVdj_gltk24iPNn4_LDNAnpECA5Jz8izdtC";
    final bool isTestEnv = WidgetsBinding.instance.toString().contains('Test');

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Premium Spott Header Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
                      (route) => false,
                    ),
                    icon: Icon(Icons.arrow_back, color: textColor),
                  ),
                  Text(
                    'SPOTT',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? Colors.white : Helper.ink,
                        width: 1.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: isTestEnv
                          ? Container(
                              color: isDark ? Colors.white : Helper.ink,
                              child: const Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            )
                          : Image.network(
                              avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: isDark ? Colors.white : Helper.ink,
                                    child: const Icon(
                                      Icons.person_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                            ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Main Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // Success Animation Pulse Circle
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (isDark ? Colors.white : Helper.ink)
                                  .withValues(alpha: isDark ? 0.08 : 0.05),
                            ),
                          ),
                          Container(
                            width: 86,
                            height: 86,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (isDark ? Colors.white : Helper.ink)
                                  .withValues(alpha: isDark ? 0.15 : 0.1),
                            ),
                          ),
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? Colors.white : Helper.ink,
                            ),
                            child: Icon(
                              Icons.task_alt_rounded,
                              color: isDark ? Helper.ink : Colors.white,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    Text(
                      'Confirm ride',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Review route, driver and payment before booking.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: subtitleColor,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Recovery Banner
                    if (ride.actionState.isFailure)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: RecoveryBanner(
                          state: ride.actionState,
                          onRetry: ride.retryInitialize,
                        ),
                      ),

                    // Booking Summary Card
                    Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor, width: 1.0),
                        boxShadow: Helper.premiumShadows,
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Vehicle Header inside Card
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Helper.ink.withValues(alpha: 0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Image.asset(
                                    vehicleAsset,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.directions_car_rounded,
                                              color: Helper.ink,
                                              size: 22,
                                            ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ride.selectedDriver?.vehicle ??
                                          'Spott Smart Car',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    Text(
                                      ride.selectedDriver?.name ??
                                          'Assigned Driver',
                                      style: TextStyle(
                                        color: subtitleColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Divider(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.06)
                                : const Color(0xFFF2F4F7),
                            height: 1,
                          ),
                          const SizedBox(height: 16),

                          // Location and Details Rows
                          _buildSummaryRow(
                            icon: Icons.pin_drop_rounded,
                            label: 'Pickup',
                            value: ride.pickup.detail,
                            isDark: isDark,
                          ),
                          _buildSummaryRow(
                            icon: Icons.location_on_rounded,
                            label: 'Drop',
                            value: ride.destination.detail,
                            isDark: isDark,
                          ),
                          _buildSummaryRow(
                            icon: Icons.person_rounded,
                            label: 'Driver',
                            value: ride.selectedDriver?.name ?? 'Matching',
                            isDark: isDark,
                          ),
                          _buildSummaryRow(
                            icon: Icons.lock_rounded,
                            label: 'Ride OTP',
                            value: 'Required',
                            valueColor: Helper.success,
                            isDark: isDark,
                          ),
                          _buildSummaryRow(
                            icon: Icons.cancel_schedule_send_rounded,
                            label: 'Cancellation',
                            value: 'Free for 2 min',
                            isDark: isDark,
                          ),
                          _buildSummaryRow(
                            icon: Icons.security_rounded,
                            label: 'Safety',
                            value: 'Trip monitored',
                            valueColor: Helper.success,
                            isDark: isDark,
                          ),

                          const SizedBox(height: 8),

                          // Inner Price Summary Panel
                          Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1A1A1A)
                                  : const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(16),
                              border: isDark
                                  ? Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.05,
                                      ),
                                      width: 1.0,
                                    )
                                  : null,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Amount',
                                      style: TextStyle(
                                        color: subtitleColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Taxes & fees included',
                                      style: TextStyle(
                                        color: subtitleColor.withValues(
                                          alpha: 0.8,
                                        ),
                                        fontSize: 11,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  ride.fareLabel,
                                  style: const TextStyle(
                                    color: Helper.ink,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Reservation Timer Info Chip
                    Container(
                      decoration: BoxDecoration(
                        color: Helper.success.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Helper.success.withValues(alpha: 0.2),
                          width: 1.0,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Helper.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Ride slot locked • Ready to book',
                            style: TextStyle(
                              color: Helper.success,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // 3. Bottom Action Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF050505)
                    : const Color(0xFFF9FAFB),
                border: Border(top: BorderSide(color: borderColor, width: 1.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.payment);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Helper.ink,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pay securely',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.maybePop(context),
                    child: Text(
                      'Modify Booking Details',
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
    Color? valueColor,
  }) {
    final titleColor = isDark
        ? const Color(0xFF8E90A2)
        : const Color(0xFF667085);
    final valColor = valueColor ?? (isDark ? Colors.white : Helper.ink);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Helper.ink),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
