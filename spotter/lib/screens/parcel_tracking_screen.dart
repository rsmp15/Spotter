import 'dart:async';
import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../models/ride_models.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../core/theme/radius.dart';

class ParcelTrackingScreen extends StatefulWidget {
  const ParcelTrackingScreen({super.key});

  @override
  State<ParcelTrackingScreen> createState() => _ParcelTrackingScreenState();
}

class _ParcelTrackingScreenState extends State<ParcelTrackingScreen> {
  final TextEditingController _pinController = TextEditingController();
  TripStatus _internalStatus = TripStatus.driverAssigned;
  Timer? _simulationTimer;

  @override
  void initState() {
    super.initState();
    _simulationTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _internalStatus = TripStatus.inProgress;
          try {
            final ride = RideScope.of(context);
            ride.updateParcelStatus(TripStatus.inProgress);
          } catch (_) {}
        });
      }
    });
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  void _verifyAndComplete(BuildContext context, RideController ride) {
    if (_pinController.text.trim() == ride.parcelVerificationPin) {
      ride.updateParcelStatus(TripStatus.completed);
      Navigator.pushNamed(context, AppRoutes.parcelComplete);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid Recipient PIN! Check with recipient (PIN is ${ride.parcelVerificationPin})'),
          backgroundColor: SpottColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final package = ride.activeParcel;
    final driver = ride.assignedParcelDriver ?? ride.drivers.first;

    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: SpottColors.textPrimary),
        title: const Text('Track Parcel', style: SpottTextStyles.sectionTitle),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(SpottSpacing.lg),
            children: [
              Text('Real-time delivery progress via private transport.', style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary)),
              const SizedBox(height: SpottSpacing.xl),

              // Map Preview
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: SpottColors.surface1,
                  borderRadius: BorderRadius.circular(SpottRadius.card),
                  border: Border.all(color: SpottColors.border),
                ),
                child: const Center(
                  child: Icon(Icons.map_rounded, size: 48, color: SpottColors.textSecondary),
                ),
              ),
              const SizedBox(height: SpottSpacing.md),

              // Active Delivery Driver details
              GlassCard(
                padding: const EdgeInsets.all(SpottSpacing.md),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: SpottColors.surface1,
                        shape: BoxShape.circle,
                        border: Border.all(color: SpottColors.border),
                      ),
                      child: Center(
                        child: Text(
                          driver.name[0],
                          style: SpottTextStyles.sectionTitle.copyWith(color: SpottColors.textPrimary),
                        ),
                      ),
                    ),
                    const SizedBox(width: SpottSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(driver.name, style: SpottTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: SpottColors.textPrimary)),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.directions_car_rounded, color: SpottColors.textSecondary, size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${driver.vehicle}  •  ${driver.rating} ★',
                                  style: SpottTextStyles.caption,
                                  overflow: TextOverflow.ellipsis,
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
                        color: SpottColors.primary.withValues(alpha: 0.15),
                        border: Border.all(color: SpottColors.primary),
                        borderRadius: BorderRadius.circular(SpottRadius.sm),
                      ),
                      child: Text(
                        _internalStatus == TripStatus.driverAssigned ? '3 mins' : 'En route',
                        style: SpottTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: SpottColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SpottSpacing.md),

              // Status Timeline Details
              GlassCard(
                padding: const EdgeInsets.all(SpottSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Delivery Milestone', style: SpottTextStyles.sectionTitle),
                    const SizedBox(height: SpottSpacing.xl),
                    _buildMilestoneRow(
                      label: 'Delivery Partner Assigned',
                      detail: 'Private driver ${driver.name} is on the way',
                      active: true,
                      completed: true,
                    ),
                    _buildMilestoneRow(
                      label: 'Package Picked Up',
                      detail: 'Driver collected items from ${package?.pickup.title ?? "Hostel Block A"}',
                      active: _internalStatus == TripStatus.inProgress,
                      completed: _internalStatus == TripStatus.inProgress,
                    ),
                    _buildMilestoneRow(
                      label: 'Delivered (Requires PIN)',
                      detail: 'Enter recipient PIN to complete transaction',
                      active: _internalStatus == TripStatus.inProgress,
                      completed: false,
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SpottSpacing.md),

              // PoD OTP verification Box
              GlassCard(
                padding: const EdgeInsets.all(SpottSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.vpn_key_rounded, color: SpottColors.primary, size: 20),
                        const SizedBox(width: SpottSpacing.sm),
                        Expanded(
                          child: Text('Enter Recipient Delivery PIN', style: SpottTextStyles.sectionTitle),
                        ),
                      ],
                    ),
                    const SizedBox(height: SpottSpacing.xs),
                    Text(
                      'Verify with receiver to get their secret 4-digit drop-off PIN.',
                      style: SpottTextStyles.caption,
                    ),
                    const SizedBox(height: SpottSpacing.lg),
                    TextField(
                      controller: _pinController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _verifyAndComplete(context, ride),
                      style: SpottTextStyles.body.copyWith(color: SpottColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'Recipient PIN',
                        hintText: 'Enter 4-digit PIN (e.g. ${ride.parcelVerificationPin})',
                        labelStyle: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary),
                        hintStyle: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary),
                        filled: true,
                        fillColor: SpottColors.surface1,
                        contentPadding: const EdgeInsets.symmetric(horizontal: SpottSpacing.md, vertical: SpottSpacing.md),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(SpottRadius.md), borderSide: BorderSide.none),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
          Positioned(
            bottom: SpottSpacing.lg,
            left: SpottSpacing.lg,
            right: SpottSpacing.lg,
            child: SpottButton.primary(
              label: 'Confirm PIN & Complete Drop',
              onPressed: () => _verifyAndComplete(context, ride),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneRow({
    required String label,
    required String detail,
    required bool active,
    required bool completed,
    bool isLast = false,
  }) {
    Widget dotIndicator;

    if (completed) {
      dotIndicator = Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: SpottColors.success.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(color: SpottColors.success, width: 2),
        ),
        child: const Center(
          child: Icon(Icons.check_rounded, size: 12, color: SpottColors.success),
        ),
      );
    } else if (active) {
      dotIndicator = Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: SpottColors.primary.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(color: SpottColors.primary, width: 2),
        ),
        child: Center(
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: SpottColors.primary, shape: BoxShape.circle),
          ),
        ),
      );
    } else {
      dotIndicator = Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: SpottColors.border, width: 2),
        ),
        child: Center(
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(color: SpottColors.border, shape: BoxShape.circle),
          ),
        ),
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              dotIndicator,
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: completed ? SpottColors.success.withValues(alpha: 0.5) : (active ? SpottColors.primary.withValues(alpha: 0.3) : SpottColors.border),
                  ),
                ),
            ],
          ),
          const SizedBox(width: SpottSpacing.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: SpottSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: SpottTextStyles.body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: active ? SpottColors.textPrimary : SpottColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    detail,
                    style: SpottTextStyles.caption.copyWith(
                      color: active ? SpottColors.textSecondary : SpottColors.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
