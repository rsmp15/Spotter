import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../app/app_routes.dart';
import '../../controllers/ride_controller.dart';
import '../../helper.dart';
import '../../models/ride_models.dart';
import '../../spotter_widgets.dart';
import '../../design_system/design_system.dart';

class SpotterTrackingPanel extends StatelessWidget {
  const SpotterTrackingPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final driver = ride.selectedDriver ?? (ride.drivers.isNotEmpty ? ride.drivers.first : null);
    final isDark = ride.isDarkMode;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;

    Widget content = Container(
      decoration: BoxDecoration(
        color: isDark
            ? palette.surface.withValues(alpha: 0.9)
            : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: isDark
            ? Border.all(
                color: palette.border,
                width: 1.5,
              )
            : null,
        boxShadow: Helper.premiumShadows,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4.5,
              decoration: BoxDecoration(
                color: palette.border,
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
                      style: DSTypography.titleLarge.copyWith(
                        color: palette.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: palette.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: palette.border,
                        ),
                      ),
                      child: Text(
                        ride.status == TripStatus.arriving ? 'Arriving soon' : 'In progress',
                        style: DSTypography.labelLarge.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                        ),
                      ),
                    ),
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

                // Driver card
                if (driver != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: palette.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: palette.border,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: palette.surface,
                          child: Text(
                            driver.name[0],
                            style: DSTypography.bodySMStrong.copyWith(
                              color: palette.textPrimary,
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
                                style: DSTypography.labelLarge.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: palette.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      driver.vehicle,
                                      style: DSTypography.caption.copyWith(
                                        color: palette.textSecondary,
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    CupertinoIcons.star_fill,
                                    size: 11,
                                    color: Color(0xFFFACC15),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    driver.rating.toString(),
                                    style: DSTypography.caption.copyWith(
                                      color: palette.textPrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: palette.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: palette.border,
                            ),
                          ),
                          child: Text(
                            driver.eta,
                            style: DSTypography.labelLarge.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: palette.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Action grid: Chat, Support, Share, Cancel (Clean borders, Sora, Cupertino icons)
                Row(
                  children: [
                    Expanded(
                      child: _ActionTile(
                        icon: CupertinoIcons.chat_bubble_fill,
                        label: 'Chat',
                        onTap: () => Navigator.pushNamed(context, AppRoutes.chat),
                        palette: palette,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ActionTile(
                        icon: CupertinoIcons.question_circle_fill,
                        label: 'Support',
                        onTap: () => Navigator.pushNamed(context, AppRoutes.support),
                        palette: palette,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _ActionTile(
                        icon: CupertinoIcons.share,
                        label: 'Share trip',
                        onTap: () => Navigator.pushNamed(context, AppRoutes.shareTrip),
                        palette: palette,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ActionTile(
                        icon: CupertinoIcons.xmark_circle_fill,
                        label: 'Cancel',
                        onTap: () => Navigator.pushNamed(context, AppRoutes.cancelRide),
                        palette: palette,
                        isDanger: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // SOS Button (Clean pill)
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.safetyToolkit),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: palette.danger,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.shield_fill, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Safety Toolkit & SOS',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // OTP Display button
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.rideOtp),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: palette.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Show ride OTP',
                      textAlign: TextAlign.center,
                      style: DSTypography.labelLarge.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: palette.onPrimary,
                      ),
                    ),
                  ),
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

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final DSColorPalette palette;
  final bool isDanger;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.palette,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final textCol = isDanger
        ? palette.danger
        : palette.textPrimary;
    final iconCol = isDanger
        ? palette.danger
        : palette.iconSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: palette.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: palette.border, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconCol, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: DSTypography.labelLarge.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: textCol,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
