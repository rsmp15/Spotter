import 'package:flutter/material.dart';
import '../spotter_widgets.dart';
import '../helper.dart';

import 'package:flutter/material.dart';
import '../spotter_widgets.dart';
import '../helper.dart';
import '../controllers/ride_controller.dart';
import '../models/spott_models.dart';

class PassengerRequestsScreen extends StatelessWidget {
  const PassengerRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final requests = ride.tripRequests.where((req) => req.status == TripRequestStatus.pending).toList();

    return SpotterScreen(
      title: 'Seat Requests',
      subtitle: 'Manage incoming requests from passengers.',
      content: requests.isEmpty
          ? [
              const SizedBox(height: 60),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox_rounded,
                      size: 64,
                      color: Helper.mutedColor(context),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No requests yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Helper.inkColor(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'When passengers request seats on your trip,\nthey will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Helper.mutedColor(context),
                      ),
                    ),
                  ],
                ),
              ),
            ]
          : requests.map((req) => _RequestCard(request: req, ride: ride)).toList(),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final TripRequest request;
  final RideController ride;

  const _RequestCard({required this.request, required this.ride});

  @override
  Widget build(BuildContext context) {
    final passengerInfo = RideController.mockPassengerDb[request.passengerId] ?? const {
      'name': 'Unknown Passenger',
      'rating': 5.0,
      'seats': 1,
    };

    final String name = passengerInfo['name'] as String;
    final double rating = passengerInfo['rating'] as double;
    final int seats = passengerInfo['seats'] as int;

    return SpotterCard(
      children: [
        Row(
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: Helper.canvasSoftColor(context),
                shape: BoxShape.circle,
                border: Border.all(color: Helper.line(context)),
              ),
              child: Center(
                child: Text(
                  name[0],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Helper.inkColor(context),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Helper.inkColor(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.star_rounded, size: 16, color: Helper.warning),
                      const SizedBox(width: 2),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Helper.mutedColor(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$seats seat${seats > 1 ? 's' : ''} requested',
                    style: TextStyle(
                      fontSize: 13,
                      color: Helper.mutedColor(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ride.rejectRequest(request.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$name rejected')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Helper.danger,
                  side: BorderSide(color: Helper.danger),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  minimumSize: const Size.fromHeight(44),
                ),
                child: const Text('Reject', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  ride.acceptRequest(request.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$name accepted')),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Helper.success,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: const Text('Accept', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
