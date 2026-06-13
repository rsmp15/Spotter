import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../controllers/ride_controller.dart';
import '../models/spott_models.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';





class PassengerRequestsScreen extends StatelessWidget {
  const PassengerRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final requests = ride.tripRequests
        .where((req) => req.status == TripRequestStatus.pending)
        .toList();

    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: DSColors.textPrimary),
        title: Text('Seat Requests', style: DSTypography.headline),
        centerTitle: true,
      ),
      body: requests.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(DSSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.inbox_rounded, size: 64, color: DSColors.textSecondary),
                    const SizedBox(height: DSSpacing.md),
                    Text('No requests yet', style: DSTypography.headline),
                    const SizedBox(height: DSSpacing.sm),
                    Text(
                      'When passengers request seats on your trip,\nthey will appear here.',
                      textAlign: TextAlign.center,
                      style: DSTypography.body.copyWith(color: DSColors.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(DSSpacing.lg),
              itemCount: requests.length,
              separatorBuilder: (context, index) => const SizedBox(height: DSSpacing.md),
              itemBuilder: (context, index) {
                return _RequestCard(request: requests[index], ride: ride);
              },
            ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final TripRequest request;
  final RideController ride;

  const _RequestCard({required this.request, required this.ride});

  @override
  Widget build(BuildContext context) {
    final passengerInfo = RideController.mockPassengerDb[request.passengerId] ??
        const {'name': 'Unknown Passenger', 'rating': 5.0, 'seats': 1};

    final String name = passengerInfo['name'] as String;
    final double rating = passengerInfo['rating'] as double;
    final int seats = passengerInfo['seats'] as int;

    return GlassCard(
      padding: const EdgeInsets.all(DSSpacing.md),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: DSColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: DSColors.border),
                ),
                child: Center(
                  child: Text(
                    name[0],
                    style: DSTypography.headline.copyWith(color: DSColors.textPrimary),
                  ),
                ),
              ),
              const SizedBox(width: DSSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(name, style: DSTypography.body.copyWith(fontWeight: FontWeight.bold, color: DSColors.textPrimary)),
                        const SizedBox(width: DSSpacing.xs),
                        const Icon(Icons.star_rounded, size: 16, color: DSColors.warning),
                        const SizedBox(width: 2),
                        Text(rating.toString(), style: DSTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text('$seats seat${seats > 1 ? 's' : ''} requested', style: DSTypography.caption),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: DSSpacing.lg),
          Row(
            children: [
              Expanded(
                child: SpottButton.ghost(
                  label: 'Reject',
                  onPressed: () {
                    ride.rejectRequest(request.id);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$name rejected')));
                  },
                ),
              ),
              const SizedBox(width: DSSpacing.md),
              Expanded(
                child: SpottButton.primary(
                  label: 'Accept',
                  onPressed: () {
                    ride.acceptRequest(request.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$name accepted'), backgroundColor: DSColors.success),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
