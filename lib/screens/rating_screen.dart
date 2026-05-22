import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int rating = 5;
  int tip = 0;

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final driver = ride.selectedDriver;

    return SpotterScreen(
      title: 'Rate your ride',
      subtitle: 'Help keep Spotter reliable.',
      content: [
        RecoveryBanner(
          state: ride.actionState,
          onRetry: () => ride.submitRating(rating: rating, tip: tip),
        ),
        RideContextCard(
          route: ride.routeLabel,
          fare: ride.fareLabel,
          driver: ride.selectedDriver?.name ?? 'Matching',
          status: ride.status.name,
        ),
        SpotterCard(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFFEAFBF4),
                  child: Text(
                    driver?.name[0] ?? 'A',
                    style: const TextStyle(
                      color: Helper.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    driver?.name ?? 'Amit Sharma',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var index = 1; index <= 5; index++)
                  IconButton(
                    onPressed: () => setState(() => rating = index),
                    icon: Icon(
                      index <= rating ? Icons.star : Icons.star_border,
                      color: Helper.warning,
                      size: 34,
                    ),
                  ),
              ],
            ),
          ],
        ),
        SpotterCard(
          children: [
            const Text(
              'Add tip',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children: [
                for (final amount in [0, 10, 20, 50])
                  ChoiceChip(
                    label: Text(amount == 0 ? 'No tip' : 'Rs $amount'),
                    selected: tip == amount,
                    onSelected: (_) => setState(() => tip = amount),
                  ),
              ],
            ),
          ],
        ),
      ],
      bottom: PrimaryAction(
        label: 'Submit rating',
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(context);
          final success = await ride.submitRating(rating: rating, tip: tip);
          if (!context.mounted) return;
          if (!success) {
            messenger.showSnackBar(
              const SnackBar(content: Text('Rating failed. Please try again.')),
            );
            return;
          }
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (route) => false,
          );
          messenger.showSnackBar(
            const SnackBar(content: Text('Thanks for rating your ride')),
          );
        },
      ),
    );
  }
}
