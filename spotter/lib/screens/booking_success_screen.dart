import 'package:flutter/material.dart';
import '../spotter_widgets.dart';
import '../helper.dart';
import '../app/app_routes.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SpotterScreen(
      title: 'Booking Confirmed!',
      subtitle: 'Your seat has been reserved successfully.',
      showBack: false,
      content: [
        const SizedBox(height: 16),
        Center(
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Helper.success.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              size: 64,
              color: Helper.success,
            ),
          ),
        ),
        const SizedBox(height: 28),
        Center(
          child: Text(
            'Booking Confirmed!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Helper.inkColor(context),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'You are all set for your trip.',
            style: TextStyle(
              fontSize: 15,
              color: Helper.mutedColor(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const SpotterCard(
          children: [
            StatusChip(label: 'Trip summary'),
            SizedBox(height: 12),
            InfoRow(label: 'Route', value: 'Pune → Mumbai'),
            InfoRow(label: 'Date', value: '5 Jun 2026'),
            InfoRow(label: 'Departure', value: '7:30 AM'),
            InfoRow(label: 'Seats booked', value: '2'),
            InfoRow(label: 'Cost share', value: 'Rs 700'),
          ],
        ),
        SpotterCard(
          children: [
            InfoRow(label: 'Traveler', value: 'Amit Sharma'),
            InfoRow(label: 'Vehicle', value: 'Swift Dzire • MH 12 AB 1234'),
            InfoRow(
              label: 'Status',
              value: 'Confirmed',
              valueColor: Helper.success,
            ),
          ],
        ),
      ],
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryAction(
            label: 'View Trip Details',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.tracking),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Helper.inkColor(context),
                side: BorderSide(color: Helper.line(context)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                minimumSize: const Size.fromHeight(56),
              ),
              child: const Text('Back to Home', style: TextStyle(fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }
}
