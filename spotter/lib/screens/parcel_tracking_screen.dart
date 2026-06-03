import 'dart:async';
import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../models/ride_models.dart';
import '../spotter_widgets.dart';
import '../white_text_field.dart';

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
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;
    final package = ride.activeParcel;
    final driver = ride.assignedParcelDriver ?? ride.drivers.first;

    final contentColor = isDark ? Colors.white : Colors.black;


    return SpotterScreen(
      title: 'Track Parcel',
      subtitle: 'Real-time delivery progress via private transport.',
      content: [
        // Map Preview
        const MapPlaceholder(height: 180),
        const SizedBox(height: 14),

        // Active Delivery Driver details
        SpotterCard(
          color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : Colors.white,
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Helper.canvasSoft,
                  child: Text(
                    driver.name[0],
                    style: const TextStyle(
                      color: Helper.ink,
                      fontSize: 20,
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
                          color: contentColor,
                        ),
                      ),
                      Text(
                        '${driver.vehicle} • ${driver.rating} ★',
                        style: const TextStyle(
                          color: Helper.muted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _internalStatus == TripStatus.driverAssigned ? '3 mins' : 'En route',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: contentColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Status Timeline Details
        SpotterCard(
          color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : Colors.white,
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Delivery Milestone',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: contentColor),
            ),
            const SizedBox(height: 16),
            _buildMilestoneRow(
              label: 'Delivery Partner Assigned',
              detail: 'Private driver ${driver.name} is on the way',
              active: true,
              completed: true,
              isDark: isDark,
            ),
            _buildMilestoneRow(
              label: 'Package Picked Up',
              detail: 'Driver collected items from ${package?.pickup.title ?? "Hostel Block A"}',
              active: _internalStatus == TripStatus.inProgress,
              completed: _internalStatus == TripStatus.inProgress,
              isDark: isDark,
            ),
            _buildMilestoneRow(
              label: 'Delivered (Requires PIN)',
              detail: 'Enter recipient PIN to complete transaction',
              active: _internalStatus == TripStatus.inProgress,
              completed: false,
              isLast: true,
              isDark: isDark,
            ),
          ],
        ),
        const SizedBox(height: 14),

        // PoD OTP verification Box
        SpotterCard(
          color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : Colors.white,
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Enter Recipient Delivery PIN',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: contentColor),
            ),
            const SizedBox(height: 4),
            const Text(
              'Verify with receiver to get their secret 4-digit drop-off PIN.',
              style: TextStyle(fontSize: 12, color: Helper.muted),
            ),
            const SizedBox(height: 12),
            WhiteTextField(
              controller: _pinController,
              labelText: 'Recipient PIN',
              hintText: 'Enter 4-digit PIN (e.g. ${ride.parcelVerificationPin})',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _verifyAndComplete(context, ride),
            ),
          ],
        ),
      ],
      bottom: PrimaryAction(
        label: 'Confirm PIN & Complete Drop',
        onPressed: () => _verifyAndComplete(context, ride),
      ),
    );
  }

  Widget _buildMilestoneRow({
    required String label,
    required String detail,
    required bool active,
    required bool completed,
    required bool isDark,
    bool isLast = false,
  }) {
    final titleColor = isDark ? Colors.white : Colors.black;
    final dotColor = completed
        ? Helper.success
        : (active ? (isDark ? Colors.white : Colors.black) : Colors.grey[350]!);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: completed ? Helper.success : Colors.grey[300]!,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: active ? titleColor : Colors.grey[500]!,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    detail,
                    style: TextStyle(
                      fontSize: 12,
                      color: active ? (isDark ? Colors.grey[400]! : Helper.muted) : Colors.grey[400]!,
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
