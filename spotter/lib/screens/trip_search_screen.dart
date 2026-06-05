import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../core/components/skeleton_route_card.dart';
import '../core/theme/redbus_theme.dart';

class TripSearchScreen extends StatefulWidget {
  const TripSearchScreen({super.key});

  @override
  State<TripSearchScreen> createState() => _TripSearchScreenState();
}

class _TripSearchScreenState extends State<TripSearchScreen> {
  final TextEditingController _sourceController =
      TextEditingController(text: 'Pune, MH');
  final TextEditingController _destController =
      TextEditingController(text: 'Mumbai, MH');
  String _selectedDate = 'Today';
  String _passengers = '1';

  bool _isSearching = false;
  bool _searchDone = false;
  Timer? _searchTimer;

  @override
  void dispose() {
    _sourceController.dispose();
    _destController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  void _triggerSearch() {
    setState(() {
      _isSearching = true;
      _searchDone = false;
    });
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchDone = true;
        });
      }
    });
  }

  void _swapCities() {
    HapticFeedback.lightImpact();
    final temp = _sourceController.text;
    _sourceController.text = _destController.text;
    _destController.text = temp;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);

    return Scaffold(
      backgroundColor: RBColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchForm(context),
                  _buildFilterChips(),
                  const SizedBox(height: 8),
                  _buildResultsSection(context, ride),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // HEADER
  // ══════════════════════════════════════════════════════════════════
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: RBColors.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 4, 16, 10),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Colors.white, size: 22),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
              ),
              const Text(
                'Find a Trip',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // SEARCH FORM (white card)
  // ══════════════════════════════════════════════════════════════════
  Widget _buildSearchForm(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(RBRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // FROM / TO
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: RBColors.divider),
              borderRadius: BorderRadius.circular(RBRadius.lg),
            ),
            child: Column(
              children: [
                _buildFieldRow(
                  icon: Icons.radio_button_checked_rounded,
                  iconColor: RBColors.green,
                  label: 'Leaving from',
                  controller: _sourceController,
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    const Divider(height: 1, color: RBColors.divider),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: _swapCities,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: RBColors.primary, width: 1.5),
                          ),
                          child: const Icon(
                            Icons.swap_vert_rounded,
                            color: RBColors.primary,
                            size: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _buildFieldRow(
                  icon: Icons.location_on_rounded,
                  iconColor: RBColors.primary,
                  label: 'Going to',
                  controller: _destController,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildTapBox(
                  icon: Icons.calendar_today_rounded,
                  label: 'Date',
                  value: _selectedDate,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now()
                          .add(const Duration(days: 365)),
                      builder: (ctx, child) => Theme(
                        data: Theme.of(ctx).copyWith(
                          colorScheme: const ColorScheme.light(
                              primary: RBColors.primary,
                              onPrimary: Colors.white),
                        ),
                        child: child!,
                      ),
                    );
                    if (date != null) {
                      setState(() =>
                          _selectedDate =
                              '${date.day}/${date.month}/${date.year}');
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTapBox(
                  icon: Icons.person_rounded,
                  label: 'Passengers',
                  value: '$_passengers Seat',
                  onTap: () {
                    setState(() {
                      int p = int.parse(_passengers);
                      p = p > 3 ? 1 : p + 1;
                      _passengers = p.toString();
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                _triggerSearch();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: RBColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(RBRadius.md),
                ),
              ),
              child: const Text(
                'SEARCH',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    color: RBColors.textLight,
                  ),
                ),
                TextField(
                  controller: controller,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: RBColors.textDark,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTapBox({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RBRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          border: Border.all(color: RBColors.divider),
          borderRadius: BorderRadius.circular(RBRadius.md),
        ),
        child: Row(
          children: [
            Icon(icon, color: RBColors.primary, size: 15),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          color: RBColors.textLight)),
                  Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: RBColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // FILTER CHIPS
  // ══════════════════════════════════════════════════════════════════
  Widget _buildFilterChips() {
    final chips = [
      'Earliest', 'Lowest Price', 'Verified', 'Women Friendly', 'AC',
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: chips.map((c) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: RBColors.divider),
              ),
              child: Text(
                c,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: RBColors.textMedium,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // RESULTS SECTION
  // ══════════════════════════════════════════════════════════════════
  Widget _buildResultsSection(BuildContext context, RideController ride) {
    if (_isSearching) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          children: [
            SkeletonRouteCard(),
            const SizedBox(height: 10),
            SkeletonRouteCard(),
          ],
        ),
      );
    }

    if (!_searchDone && ride.activeTrips.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_rounded,
                  size: 48, color: RBColors.divider),
              const SizedBox(height: 12),
              const Text(
                'Enter route and tap Search.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: RBColors.textMedium,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_searchDone && ride.activeTrips.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off_rounded,
                  size: 48, color: RBColors.orange),
              const SizedBox(height: 12),
              const Text(
                'No rides found for this route.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: RBColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Try a different date or route.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: RBColors.textLight,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${ride.activeTrips.length} rides found',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: RBColors.textDark,
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.searchResults),
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: RBColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...ride.activeTrips.map((trip) {
            final driver = ride.drivers.firstWhere(
              (d) => d.id == trip.travelerId,
              orElse: () => ride.drivers.first,
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ResultCard(
                driverName: driver.name,
                vehicleInfo: 'Car (AC)',
                rating: driver.rating.toString(),
                departureTime:
                    '${trip.departureTime.hour}:${trip.departureTime.minute.toString().padLeft(2, '0')} ${trip.departureTime.hour >= 12 ? 'PM' : 'AM'}',
                arrivalTime: '01:45 PM',
                duration: '6h 15m',
                destination: trip.destination,
                seatsLeft: trip.availableSeats,
                price: '₹${trip.pricePerSeat}',
                isFastFilling: trip.availableSeats <= 2,
                onBook: () =>
                    Navigator.pushNamed(context, AppRoutes.confirmRide),
                onDetails: () =>
                    Navigator.pushNamed(context, AppRoutes.confirmRide),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// RESULT CARD — redBus operator style
// ════════════════════════════════════════════════════════════════════
class _ResultCard extends StatelessWidget {
  final String driverName;
  final String vehicleInfo;
  final String rating;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String destination;
  final int seatsLeft;
  final String price;
  final bool isFastFilling;
  final VoidCallback onBook;
  final VoidCallback onDetails;

  const _ResultCard({
    required this.driverName,
    required this.vehicleInfo,
    required this.rating,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.destination,
    required this.seatsLeft,
    required this.price,
    required this.isFastFilling,
    required this.onBook,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDetails,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(RBRadius.lg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: time
                  Column(
                    children: [
                      Text(
                        departureTime,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: RBColors.textDark,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            Container(
                                width: 1.5,
                                height: 6,
                                color: RBColors.divider),
                            Text(
                              duration,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 9,
                                color: RBColors.textLight,
                              ),
                            ),
                            Container(
                                width: 1.5,
                                height: 6,
                                color: RBColors.divider),
                          ],
                        ),
                      ),
                      Text(
                        arrivalTime,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: RBColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  // Center: driver + destination
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driverName,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: RBColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          vehicleInfo,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: RBColors.textMedium,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          destination,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: RBColors.textLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: RBColors.gold, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              rating,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: RBColors.textDark,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.verified_rounded,
                                color: RBColors.blue, size: 12),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Right: price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: RBColors.primary,
                        ),
                      ),
                      const Text(
                        '/seat',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          color: RBColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Bottom bar
            Container(
              decoration: const BoxDecoration(
                color: RBColors.surfaceGrey,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(RBRadius.lg),
                  bottomRight: Radius.circular(RBRadius.lg),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  if (isFastFilling)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: RBColors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color:
                                RBColors.orange.withValues(alpha: 0.3)),
                      ),
                      child: const Text(
                        'Fast filling',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: RBColors.orange,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Text(
                    '$seatsLeft seats left',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: RBColors.green,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 28,
                    child: ElevatedButton(
                      onPressed: onBook,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RBColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(RBRadius.md),
                        ),
                        elevation: 0,
                        minimumSize: Size.zero,
                      ),
                      child: const Text(
                        'BOOK',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
