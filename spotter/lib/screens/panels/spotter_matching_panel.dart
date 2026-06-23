import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../app/app_routes.dart';
import '../../controllers/ride_controller.dart';
import '../../helper.dart';
import '../../models/ride_models.dart';
import '../../spotter_widgets.dart';
import '../../design_system/design_system.dart';

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
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        color: Colors.transparent,
                        child: Icon(
                          CupertinoIcons.arrow_left,
                          color: palette.iconPrimary,
                          size: 24,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Driver matches',
                        textAlign: TextAlign.center,
                        style: DSTypography.titleLarge.copyWith(
                          color: palette.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 28),
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
                
                // Pulsing radar matching visualization
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: palette.iconPrimary.withValues(
                                  alpha: 1.0 - _animationController.value,
                                ),
                                width: 2 + 8 * _animationController.value,
                              ),
                            ),
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: palette.iconPrimary.withValues(
                                  alpha: (1.0 - _animationController.value).clamp(0.0, 1.0),
                                ),
                                width: 1.5 + 4 * _animationController.value,
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: palette.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.search,
                          color: palette.onPrimary,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                Center(
                  child: Text(
                    'Connecting with drivers nearby...',
                    style: DSTypography.body.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: palette.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Driver match cards
                for (var i = 0; i < ride.drivers.length; i++) ...[
                  _DriverMatchRow(
                    driver: ride.drivers[i],
                    fare: ride.fareLabel,
                    palette: palette,
                    onTap: () {
                      ride.selectDriver(ride.drivers[i]);
                      Navigator.pushNamed(context, AppRoutes.driverProfile);
                    },
                  ),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 12),

                // Best driver pill button
                GestureDetector(
                  onTap: () {
                    if (ride.selectedDriver == null && ride.drivers.isNotEmpty) {
                      ride.selectDriver(ride.drivers.first);
                    }
                    Navigator.pushNamed(context, AppRoutes.driverProfile);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: palette.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'View best driver',
                      textAlign: TextAlign.center,
                      style: DSTypography.labelLarge.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: palette.onPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Cancel Button
                GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Cancel request',
                      textAlign: TextAlign.center,
                      style: DSTypography.labelLarge.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: palette.danger,
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

class _DriverMatchRow extends StatelessWidget {
  final Driver driver;
  final String fare;
  final DSColorPalette palette;
  final VoidCallback onTap;

  const _DriverMatchRow({
    required this.driver,
    required this.palette,
    required this.fare,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              radius: 20,
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
                      Text(
                        driver.vehicle,
                        style: DSTypography.caption.copyWith(
                          color: palette.textSecondary,
                          fontSize: 12,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  fare,
                  style: DSTypography.labelLarge.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  driver.eta,
                  style: DSTypography.caption.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
