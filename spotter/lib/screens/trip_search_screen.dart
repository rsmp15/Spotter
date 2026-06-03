import 'package:flutter/material.dart';
import '../spotter_widgets.dart';
import '../helper.dart';
import '../controllers/ride_controller.dart';
import '../app/app_routes.dart';

class TripSearchScreen extends StatelessWidget {
  const TripSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;

    return SpotterScreen(
      title: 'Find a Trip',
      subtitle: 'Search available intercity trips to share costs.',
      content: [
        SpotterCard(
          children: [
            const StatusChip(label: 'Search'),
            const SizedBox(height: 14),
            _SearchField(
              icon: Icons.my_location_rounded,
              label: 'Source city',
              isDark: isDark,
            ),
            Divider(height: 24, color: Helper.line(context)),
            _SearchField(
              icon: Icons.location_on_rounded,
              label: 'Destination city',
              isDark: isDark,
            ),
          ],
        ),
        SpotterCard(
          children: [
            Row(
              children: [
                Icon(Icons.calendar_month_rounded, size: 22, color: Helper.inkColor(context)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Select date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Helper.inkColor(context),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 90)),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Pick Date',
                      style: TextStyle(
                        color: isDark ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        PrimaryAction(
          label: 'Search Trips',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Searching available trips...')),
            );
          },
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 12),
          child: Text(
            'Available trips',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Helper.inkColor(context),
            ),
          ),
        ),
        if (ride.activeTrips.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No available trips found.',
                style: TextStyle(color: Helper.muted),
              ),
            ),
          )
        else
          ...ride.activeTrips.map((trip) {
            final driver = ride.drivers.firstWhere(
              (d) => d.id == trip.travelerId,
              orElse: () => ride.drivers.first,
            );
            final hour = trip.departureTime.hour;
            final minute = trip.departureTime.minute.toString().padLeft(2, '0');
            final ampm = hour >= 12 ? 'PM' : 'AM';
            final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
            final depTimeLabel = '$displayHour:$minute $ampm';

            return _TripResultCard(
              travelerName: driver.name,
              rating: driver.rating,
              source: trip.source,
              destination: trip.destination,
              departureTime: depTimeLabel,
              availableSeats: trip.availableSeats,
              pricePerSeat: trip.pricePerSeat,
              parcelAllowed: trip.parcelAllowed,
            );
          }),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _SearchField({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22, color: isDark ? Colors.white : Colors.black),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class _TripResultCard extends StatelessWidget {
  final String travelerName;
  final double rating;
  final String source;
  final String destination;
  final String departureTime;
  final int availableSeats;
  final int pricePerSeat;
  final bool parcelAllowed;

  const _TripResultCard({
    required this.travelerName,
    required this.rating,
    required this.source,
    required this.destination,
    required this.departureTime,
    required this.availableSeats,
    required this.pricePerSeat,
    required this.parcelAllowed,
  });

  @override
  Widget build(BuildContext context) {
    return SpotterCard(
      onTap: () => Navigator.pushNamed(context, AppRoutes.confirmRide),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          travelerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Helper.inkColor(context),
                          ),
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
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.route_rounded, size: 16, color: Helper.mutedColor(context)),
                      const SizedBox(width: 6),
                      Text(
                        '$source → $destination',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Helper.inkColor(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.schedule_rounded, size: 16, color: Helper.mutedColor(context)),
                          const SizedBox(width: 6),
                          Text(
                            departureTime,
                            style: TextStyle(
                              fontSize: 13,
                              color: Helper.mutedColor(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.event_seat_rounded, size: 16, color: Helper.mutedColor(context)),
                          const SizedBox(width: 4),
                          Text(
                            '$availableSeats seats',
                            style: TextStyle(
                              fontSize: 13,
                              color: Helper.mutedColor(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rs $pricePerSeat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Helper.inkColor(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '/seat',
                  style: TextStyle(
                    fontSize: 12,
                    color: Helper.mutedColor(context),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            if (parcelAllowed)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Helper.success.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Helper.success.withValues(alpha: 0.15)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inventory_2_rounded, size: 14, color: Helper.success),
                    const SizedBox(width: 4),
                    Text(
                      'Parcel OK',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Helper.success,
                      ),
                    ),
                  ],
                ),
              )
            else
              const SizedBox(),
            FilledButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.confirmRide),
              style: FilledButton.styleFrom(
                minimumSize: const Size(120, 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              ),
              child: const Text('Request Seat', style: TextStyle(fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ],
    );
  }
}
