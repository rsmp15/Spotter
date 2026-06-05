import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../app/app_routes.dart';
import '../core/theme/redbus_theme.dart';
import '../core/theme/animations.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  int _activeFilter = 0;
  bool _isLoading = true;
  Timer? _loadingTimer;

  static const _filters = [
    'All', '🚗 Car', '🛵 Bike', 'Women Friendly', 'AC', 'Fastest',
  ];

  @override
  void initState() {
    super.initState();
    _loadingTimer = Timer(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RBColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          _buildFilterBar(),
          Expanded(
            child: _isLoading
                ? _buildSkeletons()
                : _buildResults(context),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // RED HEADER with route summary
  // ══════════════════════════════════════════════════════════════════
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: RBColors.primary,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 22),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                  ),
                  const Expanded(
                    child: Text(
                      'Select a Ride',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.tune_rounded,
                        color: Colors.white, size: 22),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            // Route summary pill
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.radio_button_checked_rounded,
                        color: Colors.white70, size: 14),
                    const SizedBox(width: 6),
                    const Text(
                      'Pune',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.arrow_forward_rounded,
                          color: Colors.white54, size: 14),
                    ),
                    const Icon(Icons.location_on_rounded,
                        color: Colors.white70, size: 14),
                    const SizedBox(width: 6),
                    const Text(
                      'Kolhapur',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 1,
                      height: 16,
                      color: Colors.white30,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Today',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // FILTER BAR — horizontal chips on white bg
  // ══════════════════════════════════════════════════════════════════
  Widget _buildFilterBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: List.generate(_filters.length, (i) {
            final active = _activeFilter == i;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _activeFilter = i);
                },
                child: AnimatedContainer(
                  duration: SpottAnimations.fast,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: active ? RBColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: active ? RBColors.primary : RBColors.divider,
                    ),
                  ),
                  child: Text(
                    _filters[i],
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.white : RBColors.textMedium,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // SKELETON LOADING
  // ══════════════════════════════════════════════════════════════════
  Widget _buildSkeletons() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => _RBSkeletonCard(),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // RESULTS — redBus operator-card style
  // ══════════════════════════════════════════════════════════════════
  Widget _buildResults(BuildContext context) {
    final results = [
      _RideResult(
        driverName: 'Arjun K.',
        avatarSeed: 'a042581f4e29026704a',
        vehicleInfo: 'Hyundai i20 (White)',
        vehicleType: 'Car',
        rating: '4.9',
        tripCount: 542,
        departureTime: '07:30 AM',
        arrivalTime: '01:45 PM',
        duration: '6h 15m',
        origin: 'Deccan Gymkhana, Pune',
        destination: 'Central Bus Stand, Kolhapur',
        seatsAvailable: 2,
        totalSeats: 4,
        price: '₹850',
        amenities: [Icons.ac_unit_rounded, Icons.wifi_rounded, Icons.power_rounded],
        tag: 'Fastest',
        tagColor: RBColors.blue,
        verificationLevel: 4,
      ),
      _RideResult(
        driverName: 'Priya M.',
        avatarSeed: 'a042581f4e29026704b',
        vehicleInfo: 'Honda City (Silver)',
        vehicleType: 'Car',
        rating: '4.7',
        tripCount: 120,
        departureTime: '09:15 AM',
        arrivalTime: '03:30 PM',
        duration: '6h 15m',
        origin: 'Swargate, Pune',
        destination: 'Mahalaxmi Temple, Kolhapur',
        seatsAvailable: 1,
        totalSeats: 4,
        price: '₹700',
        amenities: [Icons.ac_unit_rounded, Icons.female_rounded],
        tag: '1 Seat Left',
        tagColor: RBColors.orange,
        verificationLevel: 3,
      ),
      _RideResult(
        driverName: 'Ravi S.',
        avatarSeed: 'a042581f4e29026704c',
        vehicleInfo: 'Maruti Swift (Red)',
        vehicleType: 'Car',
        rating: '4.6',
        tripCount: 47,
        departureTime: '11:00 AM',
        arrivalTime: '05:15 PM',
        duration: '6h 15m',
        origin: 'Hinjewadi, Pune',
        destination: 'Shiroli, Kolhapur',
        seatsAvailable: 3,
        totalSeats: 4,
        price: '₹950',
        amenities: [Icons.ac_unit_rounded],
        tag: '',
        tagColor: Colors.transparent,
        verificationLevel: 2,
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 100),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _RideResultCard(
        result: results[i],
        onTap: () =>
            Navigator.pushNamed(context, AppRoutes.confirmRide),
        onBook: () =>
            Navigator.pushNamed(context, AppRoutes.confirmRide),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// DATA MODEL
// ════════════════════════════════════════════════════════════════════
class _RideResult {
  final String driverName;
  final String avatarSeed;
  final String vehicleInfo;
  final String vehicleType;
  final String rating;
  final int tripCount;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String origin;
  final String destination;
  final int seatsAvailable;
  final int totalSeats;
  final String price;
  final List<IconData> amenities;
  final String tag;
  final Color tagColor;
  final int verificationLevel;

  const _RideResult({
    required this.driverName,
    required this.avatarSeed,
    required this.vehicleInfo,
    required this.vehicleType,
    required this.rating,
    required this.tripCount,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.origin,
    required this.destination,
    required this.seatsAvailable,
    required this.totalSeats,
    required this.price,
    required this.amenities,
    required this.tag,
    required this.tagColor,
    required this.verificationLevel,
  });
}

// ════════════════════════════════════════════════════════════════════
// RIDE RESULT CARD — redBus bus-operator card style
// ════════════════════════════════════════════════════════════════════
class _RideResultCard extends StatelessWidget {
  final _RideResult result;
  final VoidCallback onTap;
  final VoidCallback onBook;

  const _RideResultCard({
    required this.result,
    required this.onTap,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            // ── Top: Driver + Route ────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Driver avatar + name
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(
                            'https://i.pravatar.cc/150?u=${result.avatarSeed}'),
                        onBackgroundImageError: (exception, stackTrace) {},
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: RBColors.gold, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            result.rating,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: RBColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Center: Name + vehicle + time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              result.driverName,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: RBColors.textDark,
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Verification stars
                            Row(
                              children: List.generate(
                                result.verificationLevel,
                                (i) => const Icon(Icons.verified_rounded,
                                    color: RBColors.blue, size: 11),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          result.vehicleInfo,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: RBColors.textMedium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Time row
                        Row(
                          children: [
                            Text(
                              result.departureTime,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: RBColors.textDark,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 1,
                                          color: RBColors.divider,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Text(
                                          result.duration,
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 10,
                                            color: RBColors.textLight,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 1,
                                          color: RBColors.divider,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              result.arrivalTime,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: RBColors.textDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                result.origin,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  color: RBColors.textLight,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                result.destination,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  color: RBColors.textLight,
                                ),
                                textAlign: TextAlign.right,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Right: Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        result.price,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 19,
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

            const SizedBox(height: 10),

            // ── Bottom strip: amenities + seats + tag + book ──────
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
                  // Amenity icons
                  ...result.amenities.map(
                    (icon) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Tooltip(
                        message: _amenityLabel(icon),
                        child: Icon(icon,
                            size: 16, color: RBColors.textMedium),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Tag badge
                  if (result.tag.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: result.tagColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color:
                                result.tagColor.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        result.tag,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: result.tagColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  // Seats
                  Text(
                    '${result.seatsAvailable} seats left',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: RBColors.green,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Book button
                  SizedBox(
                    height: 30,
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
                          fontSize: 12,
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

  String _amenityLabel(IconData icon) {
    if (icon == Icons.ac_unit_rounded) return 'AC';
    if (icon == Icons.wifi_rounded) return 'WiFi';
    if (icon == Icons.power_rounded) return 'Charging';
    if (icon == Icons.female_rounded) return 'Women Friendly';
    return '';
  }
}

// ════════════════════════════════════════════════════════════════════
// SKELETON CARD
// ════════════════════════════════════════════════════════════════════
class _RBSkeletonCard extends StatefulWidget {
  @override
  State<_RBSkeletonCard> createState() => _RBSkeletonCardState();
}

class _RBSkeletonCardState extends State<_RBSkeletonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 0.9).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: _anim.value * 0.15),
          borderRadius: BorderRadius.circular(RBRadius.lg),
        ),
      ),
    );
  }
}
