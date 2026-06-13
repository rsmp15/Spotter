import 'package:spotter/design_system/design_system.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../models/ride_models.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';





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
          backgroundColor: DSColors.primary,
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
        leading: const BackButton(color: DSColors.textPrimary),
        title: Text('Track Parcel', style: DSTypography.headline),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(DSSpacing.lg),
            children: [
              Text('Real-time delivery progress via private transport.', style: DSTypography.body.copyWith(color: DSColors.textSecondary)),
              const SizedBox(height: DSSpacing.xl),

              // Map Preview
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: DSColors.surface,
                  borderRadius: BorderRadius.circular(DSRadius.card),
                  border: Border.all(color: DSColors.border),
                ),
                child: const Center(
                  child: Icon(Icons.map_rounded, size: 48, color: DSColors.textSecondary),
                ),
              ),
              const SizedBox(height: DSSpacing.md),

              // Active Delivery Driver details
              GlassCard(
                padding: const EdgeInsets.all(DSSpacing.md),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: DSColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: DSColors.border),
                      ),
                      child: Center(
                        child: Text(
                          driver.name[0],
                          style: DSTypography.headline.copyWith(color: DSColors.textPrimary),
                        ),
                      ),
                    ),
                    const SizedBox(width: DSSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(driver.name, style: DSTypography.body.copyWith(fontWeight: FontWeight.bold, color: DSColors.textPrimary)),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.directions_car_rounded, color: DSColors.textSecondary, size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${driver.vehicle}  •  ${driver.rating} ★',
                                  style: DSTypography.caption,
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
                        color: DSColors.primary.withValues(alpha: 0.15),
                        border: Border.all(color: DSColors.primary),
                        borderRadius: BorderRadius.circular(DSRadius.sm),
                      ),
                      child: Text(
                        _internalStatus == TripStatus.driverAssigned ? '3 mins' : 'En route',
                        style: DSTypography.caption.copyWith(fontWeight: FontWeight.bold, color: DSColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: DSSpacing.md),

              // Status Timeline Details
              GlassCard(
                padding: const EdgeInsets.all(DSSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Delivery Milestone', style: DSTypography.headline),
                    const SizedBox(height: DSSpacing.xl),
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
              const SizedBox(height: DSSpacing.md),

              // PoD OTP verification Box
              GlassCard(
                padding: const EdgeInsets.all(DSSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.vpn_key_rounded, color: DSColors.primary, size: 20),
                        const SizedBox(width: DSSpacing.sm),
                        Expanded(
                          child: Text('Enter Recipient Delivery PIN', style: DSTypography.headline),
                        ),
                      ],
                    ),
                    const SizedBox(height: DSSpacing.xs),
                    Text(
                      'Verify with receiver to get their secret 4-digit drop-off PIN.',
                      style: DSTypography.caption,
                    ),
                    const SizedBox(height: DSSpacing.lg),
                    TextField(
                      controller: _pinController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _verifyAndComplete(context, ride),
                      style: DSTypography.body.copyWith(color: DSColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'Recipient PIN',
                        hintText: 'Enter 4-digit PIN (e.g. ${ride.parcelVerificationPin})',
                        labelStyle: DSTypography.body.copyWith(color: DSColors.textSecondary),
                        hintStyle: DSTypography.body.copyWith(color: DSColors.textSecondary),
                        filled: true,
                        fillColor: DSColors.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.md),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(DSRadius.md), borderSide: BorderSide.none),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
          Positioned(
            bottom: DSSpacing.lg,
            left: DSSpacing.lg,
            right: DSSpacing.lg,
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
          color: DSColors.success.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(color: DSColors.success, width: 2),
        ),
        child: const Center(
          child: Icon(Icons.check_rounded, size: 12, color: DSColors.success),
        ),
      );
    } else if (active) {
      dotIndicator = Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: DSColors.primary.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(color: DSColors.primary, width: 2),
        ),
        child: Center(
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: DSColors.primary, shape: BoxShape.circle),
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
          border: Border.all(color: DSColors.border, width: 2),
        ),
        child: Center(
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(color: DSColors.border, shape: BoxShape.circle),
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
                    color: completed ? DSColors.success.withValues(alpha: 0.5) : (active ? DSColors.primary.withValues(alpha: 0.3) : DSColors.border),
                  ),
                ),
            ],
          ),
          const SizedBox(width: DSSpacing.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: DSSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: DSTypography.body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: active ? DSColors.textPrimary : DSColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    detail,
                    style: DSTypography.caption.copyWith(
                      color: active ? DSColors.textSecondary : DSColors.textSecondary.withValues(alpha: 0.7),
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
