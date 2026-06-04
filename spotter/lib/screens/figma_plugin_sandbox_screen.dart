import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../helper.dart';
import '../spotter_widgets.dart';
import '../custom_button.dart';

class FigmaPluginSandboxScreen extends StatelessWidget {
  const FigmaPluginSandboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Debug-gate this screen for safety
    if (!kDebugMode) {
      return const Scaffold(
        body: Center(
          child: Text('Developer sandbox is only available in Debug Mode.'),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contentColor = isDark ? Colors.white : Colors.black;

    return SpotterScreen(
      title: 'UI Sandbox',
      subtitle: 'Preview the 10 Figma Plugin design systems.',
      showBack: true,
      content: [
        // 1. Ride Sharing (Passenger <=> Traveler)
        _buildSectionHeader(context, '1. Ride Sharing Options'),
        SpotterCard(
          padding: const EdgeInsets.all(16),
          children: [
            const StatusChip(label: 'Passenger Mode', color: Helper.accent),
            const SizedBox(height: 12),
            _buildInfoRow(context, 'Traveler Match', 'Amit Sharma (Car)'),
            _buildInfoRow(context, 'Price Shared', '₹280 (65% Recovery)'),
            _buildInfoRow(context, 'Status', 'Accepted & En Route'),
          ],
        ),

        // 2. Parcel Delivery Along Route
        _buildSectionHeader(context, '2. Parcel Delivery Tracking'),
        SpotterCard(
          padding: const EdgeInsets.all(16),
          children: [
            const StatusChip(label: 'In Transit', color: Helper.warning),
            const SizedBox(height: 12),
            _buildInfoRow(context, 'Package Size', 'Medium (Laundry)'),
            _buildInfoRow(context, 'Receiver PIN', '4820 (Required)'),
            const SizedBox(height: 10),
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.65,
                child: Container(
                  decoration: BoxDecoration(
                    color: Helper.accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),

        // 3. Safety Hub & Emergency Features
        _buildSectionHeader(context, '3. Safety Hub & SOS'),
        SpotterCard(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🚨  Emergency Alert',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: contentColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Press & hold to notify safety hub.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Helper.mutedColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onLongPress: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mock SOS Alert Sent!')),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Helper.primary,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Helper.primary.withOpacity(0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Text(
                      'SOS Trigger',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // 4. Verification Center
        _buildSectionHeader(context, '4. Verification Statuses'),
        SpotterCard(
          padding: const EdgeInsets.all(16),
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                StatusChip(label: 'KYC Approved', color: Helper.success),
                StatusChip(label: 'RC Pending', color: Helper.warning),
                StatusChip(label: 'Insurance Rejected', color: Helper.primary),
                StatusChip(label: 'DL Approved', color: Helper.success),
              ],
            ),
          ],
        ),

        // 5. Trust System
        _buildSectionHeader(context, '5. Trust Score Profiles'),
        SpotterCard(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Helper.success.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shield_rounded,
                    color: Helper.success,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Premium Trust Score',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: contentColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Score: 98/100 (Top 5% Traveler)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Helper.mutedColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        // 6. Live Tracking Route Timeline
        _buildSectionHeader(context, '6. Route Milestones'),
        SpotterCard(
          padding: const EdgeInsets.all(16),
          children: [
            _buildStepperRow(context, 'Trip Created', '10:15 AM', true),
            _buildStepperRow(context, 'Traveler Pickup', '10:30 AM', true),
            _buildStepperRow(
              context,
              'Completed drop-off',
              'Pending',
              false,
              isLast: true,
            ),
          ],
        ),

        // 7. Shared Trips (Bento Layout)
        _buildSectionHeader(context, '7. Shared Co-Riders'),
        SpotterCard(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                _buildAvatarWidget(context, 'A', Helper.accent),
                const SizedBox(width: 8),
                _buildAvatarWidget(context, 'P', Helper.success),
                const SizedBox(width: 8),
                _buildAvatarWidget(context, 'N', Helper.warning),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '3 active pool matches sharing cost on Baner Route.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Helper.mutedColor(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // 8. Explore Feed Recommendations
        _buildSectionHeader(context, '8. Explore Recommended Routes'),
        Row(
          children: [
            Expanded(
              child: SpotterCard(
                padding: const EdgeInsets.all(12),
                children: [
                  const Icon(
                    Icons.beach_access_rounded,
                    color: Helper.accent,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lonavala Weekend',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: contentColor,
                    ),
                  ),
                  Text(
                    'Recommended route',
                    style: TextStyle(
                      fontSize: 11,
                      color: Helper.mutedColor(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SpotterCard(
                padding: const EdgeInsets.all(12),
                children: [
                  const Icon(
                    Icons.business_rounded,
                    color: Helper.primary,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hinjawadi IT Park',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: contentColor,
                    ),
                  ),
                  Text(
                    'Daily commute route',
                    style: TextStyle(
                      fontSize: 11,
                      color: Helper.mutedColor(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // 9. Notification Center Messages
        _buildSectionHeader(context, '9. Premium Notifications'),
        SpotterCard(
          padding: const EdgeInsets.all(12),
          children: [
            _buildNotificationRow(
              context,
              '⚡ Match Found',
              'Amit Sharma accepted your ride share.',
            ),
            const SizedBox(height: 8),
            _buildNotificationRow(
              context,
              '📦 Delivery Picked Up',
              'Package in transit with OTP verification.',
            ),
          ],
        ),

        // 10. Vehicle Management
        _buildSectionHeader(context, '10. Verified Vehicle Hub'),
        SpotterCard(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Icon(
                  Icons.directions_car_rounded,
                  color: Helper.accent,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Honda City (MH-12-PQ-9876)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: contentColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Registered vehicle • Verified Status',
                        style: TextStyle(
                          fontSize: 12,
                          color: Helper.mutedColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.verified_user_rounded,
                  color: Helper.success,
                  size: 18,
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8, left: 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Helper.mutedColor(context),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Helper.mutedColor(context), fontSize: 13),
          ),
          Text(
            value,
            style: TextStyle(
              color: Helper.inkColor(context),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperRow(
    BuildContext context,
    String title,
    String time,
    bool completed, {
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: completed ? Helper.success : Colors.grey[400],
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 24,
                color: completed ? Helper.success : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: completed
                      ? Helper.inkColor(context)
                      : Helper.mutedColor(context),
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: Helper.mutedColor(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarWidget(BuildContext context, String initial, Color color) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.5),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationRow(
    BuildContext context,
    String header,
    String body,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(top: 5),
          decoration: const BoxDecoration(
            color: Helper.accent,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                header,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Helper.inkColor(context),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                body,
                style: TextStyle(
                  fontSize: 12,
                  color: Helper.mutedColor(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
