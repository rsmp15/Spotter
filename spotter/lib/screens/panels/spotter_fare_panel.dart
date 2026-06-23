import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../app/app_assets.dart';
import '../../app/app_routes.dart';
import '../../controllers/ride_controller.dart';
import '../../helper.dart';
import '../../models/ride_models.dart';
import '../../spotter_widgets.dart';
import '../../design_system/design_system.dart';

class SpotterFarePanel extends StatelessWidget {
  const SpotterFarePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final selectedOption = ride.selectedRideOption ?? (ride.rideOptions.isNotEmpty ? ride.rideOptions.first : null);
    final isDark = ride.isDarkMode;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;

    final fare = selectedOption?.fare ?? 0;
    final base = (fare * 0.52).round();
    final distance = (fare * 0.36).round();
    final demand = fare - base - distance;

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
                // Header Title
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
                        'Price estimate',
                        textAlign: TextAlign.center,
                        style: DSTypography.titleLarge.copyWith(
                          color: palette.textPrimary,
                          fontSize: 20,
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

                // Vertical Ride Options List
                Column(
                  children: [
                    for (final option in ride.rideOptions) ...[
                      _RideOptionRow(
                        option: option,
                        selected: selectedOption?.id == option.id,
                        palette: palette,
                        onTap: () {
                          ride.selectRideOption(option);
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                // Fare Breakdown card
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fare breakup',
                        style: DSTypography.labelLarge.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _BreakdownRow(label: 'Base fare', value: 'Rs $base', palette: palette),
                      const SizedBox(height: 6),
                      _BreakdownRow(label: 'Distance', value: 'Rs $distance', palette: palette),
                      const SizedBox(height: 6),
                      _BreakdownRow(label: 'Demand surcharge', value: 'Rs $demand', palette: palette),
                      if (selectedOption?.id == 'pool' || selectedOption?.id == 'bike_pool') ...[
                        const SizedBox(height: 6),
                        _BreakdownRow(
                          label: 'Multi-rider Split Savings',
                          value: '-Rs 34',
                          palette: palette,
                          valueColor: const Color(0xFF4CAF50),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Divider(color: palette.divider),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Estimated total',
                            style: DSTypography.labelLarge.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: palette.textPrimary,
                            ),
                          ),
                          Text(
                            ride.fareLabel,
                            style: DSTypography.labelLarge.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: palette.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Pooling matches (co-riders list)
                if (selectedOption?.id == 'pool' || selectedOption?.id == 'bike_pool') ...[
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Co-Riders Matched',
                          style: DSTypography.labelLarge.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: palette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: palette.surface,
                              child: Text('A', style: DSTypography.bodySMStrong.copyWith(fontSize: 10, color: palette.textPrimary, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Aarav S. • ★ 4.8',
                              style: DSTypography.body.copyWith(
                                fontSize: 12,
                                color: palette.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: palette.surface,
                              child: Text('R', style: DSTypography.bodySMStrong.copyWith(fontSize: 10, color: palette.textPrimary, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Rohit M. • ★ 4.7',
                              style: DSTypography.body.copyWith(
                                fontSize: 12,
                                color: palette.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(color: palette.divider),
                        const SizedBox(height: 8),
                        Text(
                          'Shared Stop Sequence',
                          style: DSTypography.labelLarge.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: palette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '1. Pickup You (Baner)',
                          style: DSTypography.caption.copyWith(
                            fontSize: 12,
                            color: palette.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Confirm CTA
                GestureDetector(
                  onTap: () {
                    if (selectedOption != null) {
                      ride.selectRideOption(selectedOption);
                    }
                    Navigator.pushNamed(context, AppRoutes.drivers);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: palette.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Find drivers',
                      textAlign: TextAlign.center,
                      style: DSTypography.labelLarge.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: palette.onPrimary,
                        letterSpacing: -0.2,
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

class _RideOptionRow extends StatelessWidget {
  final RideOption option;
  final bool selected;
  final DSColorPalette palette;
  final VoidCallback onTap;

  const _RideOptionRow({
    required this.option,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final assetPath = AppAssets.forRideId(option.id);
    final fallbackIcon = _fallbackIconFor(option);

    final rowBgColor = selected
        ? palette.surfaceVariant
        : Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: rowBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? palette.primary
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Vehicle Image/Icon left
            Image.asset(
              assetPath,
              width: 52,
              height: 40,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(fallbackIcon, size: 36, color: palette.iconPrimary);
              },
            ),
            const SizedBox(width: 16),

            // Vehicle Details center
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        option.name,
                        style: DSTypography.labelLarge.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        CupertinoIcons.person_fill,
                        size: 12,
                        color: palette.iconSecondary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        _seatsFor(option),
                        style: DSTypography.caption.copyWith(
                          fontSize: 12,
                          color: palette.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    option.detail,
                    style: DSTypography.caption.copyWith(
                      fontSize: 12,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Fare right
            Text(
              option.fareLabel,
              style: DSTypography.labelLarge.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: palette.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _seatsFor(RideOption option) {
    if (option.id.contains('moto') || option.id.contains('bike')) return '1';
    if (option.id.contains('auto')) return '3';
    if (option.id.contains('xl')) return '6';
    return '4';
  }

  IconData _fallbackIconFor(RideOption option) {
    switch (option.id) {
      case 'moto':
      case 'bike':
        return CupertinoIcons.location;
      case 'auto':
      case 'rickshaw':
        return CupertinoIcons.square_grid_2x2;
      default:
        return CupertinoIcons.car_detailed;
    }
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final String value;
  final DSColorPalette palette;
  final Color? valueColor;

  const _BreakdownRow({
    required this.label,
    required this.value,
    required this.palette,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: DSTypography.caption.copyWith(
            fontSize: 12,
            color: palette.textSecondary,
          ),
        ),
        Text(
          value,
          style: DSTypography.caption.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: valueColor ?? palette.textPrimary,
          ),
        ),
      ],
    );
  }
}
