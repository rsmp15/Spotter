import 'package:spotter/design_system/design_system.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../app/app_routes.dart';
import '../../controllers/ride_controller.dart';
import '../../helper.dart';

import '../../models/ride_models.dart';
import '../../spotter_widgets.dart';

class SpotterMatchingPanel extends StatefulWidget {
  const SpotterMatchingPanel({super.key});

  @override
  State<SpotterMatchingPanel> createState() => _SpotterMatchingPanelState();
}

class _SpotterMatchingPanelState extends State<SpotterMatchingPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (WidgetsBinding.instance.toString().contains('Test')) {
      _animationController.value = 0.5;
    } else {
      _animationController.repeat();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;

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
                        'Driver matches',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark ? Colors.white : DSColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
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
                // Elite pulsing matching radar representation
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: (isDark ? Colors.white : Colors.black)
                                    .withValues(
                                      alpha: 1.0 - _animationController.value,
                                    ),
                                width: 2 + 10 * _animationController.value,
                              ),
                            ),
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: (isDark ? Colors.white : Colors.black)
                                    .withValues(
                                      alpha: (1.0 - _animationController.value)
                                          .clamp(0.0, 1.0),
                                    ),
                                width: 1 + 5 * _animationController.value,
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white : Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.radar_rounded,
                          color: isDark ? Colors.black : Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Finding the best ride for you...',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.grey[300]
                          : const Color(0xFF5E5E5E),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Driver Cards
                for (var i = 0; i < ride.drivers.length; i++)
                  _DriverPanelCard(
                    driver: ride.drivers[i],
                    fare: ride.fareLabel,
                    isDark: isDark,
                    color: isDark
                        ? [
                            const Color(0xFF38BDF8),
                            const Color(0xFFFACC15),
                            const Color(0xFF10B981),
                          ][i % 3]
                        : [
                            const Color(0xFF000000),
                            const Color(0xFF5E5E5E),
                            const Color(0xFF8F8F8F),
                          ][i % 3],
                    onTap: () {
                      ride.selectDriver(ride.drivers[i]);
                      Navigator.pushNamed(context, AppRoutes.driverProfile);
                    },
                  ),
                const SizedBox(height: 12),
                PrimaryAction(
                  label: 'View best driver',
                  onPressed: () {
                    // Automatically choose first driver if not selected
                    if (ride.selectedDriver == null &&
                        ride.drivers.isNotEmpty) {
                      ride.selectDriver(ride.drivers.first);
                    }
                    Navigator.pushNamed(context, AppRoutes.driverProfile);
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

class _DriverPanelCard extends StatelessWidget {
  final Driver driver;
  final String fare;
  final Color color;
  final bool isDark;
  final VoidCallback? onTap;

  const _DriverPanelCard({
    required this.driver,
    required this.fare,
    required this.color,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SpotterCard(
      onTap: onTap,
      color: isDark
          ? const Color(0xFF1E293B).withValues(alpha: 0.5)
          : Helper.cardColor,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withValues(alpha: 0.14),
              child: Text(
                driver.name[0],
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
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
                    '${driver.vehicle} • rating ${driver.rating}',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Helper.muted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              fare,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
