import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../core/components/skeleton_route_card.dart';
import '../core/theme/colors.dart';
import '../core/theme/radius.dart';
import '../core/theme/shadows.dart';
import '../core/theme/typography.dart';
import '../core/components/premium_chips.dart';
import '../widgets/premium/premium_selectors.dart';

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
  int _activeFilter = 0;

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
      backgroundColor: SpottColors.background,
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
                  const SizedBox(height: 12),
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
      color: SpottColors.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 4, 16, 12),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Colors.white, size: 22),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
              ),
              Text(
                'Find a Trip',
                style: SpottTextStyles.headline.copyWith(
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
  // SEARCH FORM (Premium Booking Card)
  // ══════════════════════════════════════════════════════════════════
  Widget _buildSearchForm(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SpottRadius.card),
        boxShadow: SpottShadows.elevation2,
        border: Border.all(color: SpottColors.border),
      ),
      child: Column(
        children: [
          // FROM / TO
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: SpottColors.border),
              borderRadius: BorderRadius.circular(SpottRadius.lg),
              color: SpottColors.surface2,
            ),
            child: Column(
              children: [
                _buildFieldRow(
                  icon: Icons.radio_button_checked_rounded,
                  iconColor: SpottColors.success,
                  label: 'Leaving from',
                  controller: _sourceController,
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    const Divider(height: 1, color: SpottColors.divider),
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
                                color: SpottColors.primary, width: 1.5),
                            boxShadow: SpottShadows.elevation1,
                          ),
                          child: const Icon(
                            Icons.swap_vert_rounded,
                            color: SpottColors.primary,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _buildFieldRow(
                  icon: Icons.location_on_rounded,
                  iconColor: SpottColors.primary,
                  label: 'Going to',
                  controller: _destController,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTapBox(
                  icon: Icons.calendar_today_rounded,
                  label: 'Date',
                  value: _selectedDate,
                  onTap: () async {
                    DateTime initDate;
                    try {
                      final parts = _selectedDate.split('/');
                      if (parts.length == 3) {
                        initDate = DateTime(
                          int.parse(parts[2]),
                          int.parse(parts[1]),
                          int.parse(parts[0]),
                        );
                      } else {
                        initDate = DateTime.now();
                      }
                    } catch (_) {
                      initDate = DateTime.now();
                    }

                    final date = await PremiumDatePickerBottomSheet.show(
                      context,
                      initialDate: initDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      primaryColor: SpottColors.primary,
                    );
                    if (date != null) {
                      setState(() =>
                          _selectedDate =
                              '${date.day}/${date.month}/${date.year}');
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildTapBox(
                  icon: Icons.person_rounded,
                  label: 'Passengers',
                  value: '$_passengers Seat',
                  onTap: () async {
                    final currentVal = int.tryParse(_passengers) ?? 1;
                    final picked = await PremiumPassengersBottomSheet.show(
                      context,
                      initialSeats: currentVal,
                      maxSeats: 4,
                      primaryColor: SpottColors.primary,
                      title: 'Select Seats',
                      subtitle: 'Choose how many seats to book',
                    );
                    if (picked != null) {
                      setState(() {
                        _passengers = picked.toString();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                _triggerSearch();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: SpottColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SpottRadius.button),
                ),
                textStyle: SpottTextStyles.label.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              child: const Text('SEARCH'),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: SpottTextStyles.caption.copyWith(
                    color: SpottColors.textTertiary,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 2),
                TextField(
                  controller: controller,
                  style: SpottTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    color: SpottColors.textPrimary,
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
      borderRadius: BorderRadius.circular(SpottRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: SpottColors.border),
          borderRadius: BorderRadius.circular(SpottRadius.lg),
          color: SpottColors.surface2,
        ),
        child: Row(
          children: [
            Icon(icon, color: SpottColors.primary, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: SpottTextStyles.caption.copyWith(
                      color: SpottColors.textTertiary,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: SpottTextStyles.body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: SpottColors.textPrimary,
                      fontSize: 13,
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(chips.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PremiumFilterChip(
              label: chips[i],
              isSelected: _activeFilter == i,
              onTap: () {
                setState(() => _activeFilter = i);
              },
            ),
          );
        }),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // RESULTS SECTION
  // ══════════════════════════════════════════════════════════════════
  Widget _buildResultsSection(BuildContext context, RideController ride) {
    if (_isSearching) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            SkeletonRouteCard(),
            SizedBox(height: 12),
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
              const Icon(Icons.search_rounded,
                  size: 48, color: SpottColors.border),
              const SizedBox(height: 12),
              Text(
                'Enter route and tap Search.',
                style: SpottTextStyles.body.copyWith(
                  color: SpottColors.textSecondary,
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
              const Icon(Icons.search_off_rounded,
                  size: 48, color: SpottColors.warning),
              const SizedBox(height: 12),
              Text(
                'No rides found for this route.',
                style: SpottTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: SpottColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Try a different date or route.',
                style: SpottTextStyles.caption.copyWith(
                  color: SpottColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${ride.activeTrips.length} rides found',
                  style: SpottTextStyles.label.copyWith(
                    fontWeight: FontWeight.bold,
                    color: SpottColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.searchResults),
                  child: Text(
                    'View All',
                    style: SpottTextStyles.label.copyWith(
                      fontWeight: FontWeight.bold,
                      color: SpottColors.primary,
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
              padding: const EdgeInsets.only(bottom: 12),
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
// RESULT CARD
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
          borderRadius: BorderRadius.circular(SpottRadius.card),
          boxShadow: SpottShadows.elevation1,
          border: Border.all(color: SpottColors.border),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: time column
                  Column(
                    children: [
                      Text(
                        departureTime,
                        style: SpottTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                          color: SpottColors.textPrimary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            Container(width: 1.5, height: 8, color: SpottColors.border),
                            Text(
                              duration,
                              style: SpottTextStyles.caption.copyWith(
                                fontSize: 9,
                                color: SpottColors.textSecondary,
                              ),
                            ),
                            Container(width: 1.5, height: 8, color: SpottColors.border),
                          ],
                        ),
                      ),
                      Text(
                        arrivalTime,
                        style: SpottTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                          color: SpottColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Center: driver info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driverName,
                          style: SpottTextStyles.body.copyWith(
                            fontWeight: FontWeight.bold,
                            color: SpottColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          vehicleInfo,
                          style: SpottTextStyles.caption.copyWith(
                            color: SpottColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          destination,
                          style: SpottTextStyles.caption.copyWith(
                            color: SpottColors.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: SpottColors.warning, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              rating,
                              style: SpottTextStyles.caption.copyWith(
                                fontWeight: FontWeight.bold,
                                color: SpottColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.verified_rounded,
                                color: SpottColors.info, size: 14),
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
                        style: SpottTextStyles.title.copyWith(
                          fontWeight: FontWeight.w800,
                          color: SpottColors.primary,
                        ),
                      ),
                      Text(
                        '/seat',
                        style: SpottTextStyles.caption.copyWith(
                          color: SpottColors.textSecondary,
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
                color: SpottColors.surface2,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(SpottRadius.card),
                  bottomRight: Radius.circular(SpottRadius.card),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  if (isFastFilling)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: SpottColors.warningSoft,
                        borderRadius: BorderRadius.circular(SpottRadius.xs),
                        border: Border.all(color: SpottColors.warning.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        'Fast filling',
                        style: SpottTextStyles.caption.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: SpottColors.warning,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Text(
                    '$seatsLeft seats left',
                    style: SpottTextStyles.caption.copyWith(
                      fontWeight: FontWeight.bold,
                      color: SpottColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: onBook,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SpottColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(SpottRadius.sm),
                        ),
                        textStyle: SpottTextStyles.caption.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('BOOK'),
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
