import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../models/ride_models.dart';
import '../spotter_widgets.dart';

class ParcelCompleteScreen extends StatefulWidget {
  const ParcelCompleteScreen({super.key});

  @override
  State<ParcelCompleteScreen> createState() => _ParcelCompleteScreenState();
}

class _ParcelCompleteScreenState extends State<ParcelCompleteScreen> {
  int _userRating = 5;

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;
    final package = ride.activeParcel;
    final driver = ride.assignedParcelDriver ?? ride.drivers.first;

    final contentColor = isDark ? Colors.white : Colors.black;

    return SpotterScreen(
      title: 'Delivery Receipt',
      subtitle: 'Package successfully delivered!',
      content: [
        // Success Avatar Glow
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Helper.success.withValues(alpha: 0.1),
                ),
              ),
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Helper.success,
                ),
                child: const Icon(
                  Icons.done_all_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Receipt Summary Box
        SpotterCard(
          color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : Colors.white,
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Transaction Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: contentColor),
            ),
            const SizedBox(height: 12),
            InfoRow(label: 'Sender', value: package?.senderName ?? 'Ritesh M'),
            InfoRow(label: 'Receiver', value: package?.receiverName ?? 'Rahul Sharma'),
            InfoRow(
              label: 'Category',
              value: package == null
                  ? 'Documents'
                  : package.category.name.replaceAll('documents', 'Documents / Keys').replaceAll('collegeItems', 'College Items'),
            ),
            InfoRow(
              label: 'Weight class',
              value: package == null ? 'Light' : package.size.name.toUpperCase(),
            ),
            InfoRow(label: 'Vehicle type', value: driver.vehicle.split(' - ')[0]),
            Divider(color: isDark ? Colors.white10 : const Color(0xFFEFEFEF), height: 16),
            InfoRow(
              label: 'Amount Charged',
              value: package?.fareLabel ?? 'Rs 45',
              valueColor: Helper.success,
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Photo Proof placeholder Box
        SpotterCard(
          color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : Colors.white,
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Proof of Delivery (Photo)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: contentColor),
            ),
            const SizedBox(height: 10),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.photo_library_outlined,
                    size: 32,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Verification Photo Uploaded by ${driver.name}',
                    style: const TextStyle(fontSize: 12, color: Helper.muted, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Private Driver Partner rating Star selector
        SpotterCard(
          color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : Colors.white,
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Text(
                'Rate ${driver.name}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: contentColor),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starPos = index + 1;
                return IconButton(
                  icon: Icon(
                    starPos <= _userRating ? Icons.star_rounded : Icons.star_border_rounded,
                    color: const Color(0xFFFF8A00),
                    size: 36,
                  ),
                  onPressed: () {
                    setState(() {
                      _userRating = starPos;
                    });
                  },
                );
              }),
            ),
          ],
        ),
      ],
      bottom: PrimaryAction(
        label: 'Return to Home',
        onPressed: () {
          ride.clearParcelBooking();
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
        },
      ),
    );
  }
}
