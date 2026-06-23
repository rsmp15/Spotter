import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';




import '../core/components/premium_chips.dart';
import '../core/components/skeleton_route_card.dart';

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
    'All', 'Earliest', 'Lowest Price', '🚗 Car', '🛵 Bike', 'Women Friendly', 'AC',
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
    final ride = RideScope.of(context);
    final palette = ride.isDarkMode ? DSPalettes.dark : DSPalettes.light;
    return Scaffold(
      backgroundColor: palette.background,
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
  // HEADER with route summary
  // ══════════════════════════════════════════════════════════════════
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
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
                        color: DSColors.textPrimary, size: 22),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                  ),
                  Expanded(
                    child: Text(
                      'Find a Trip',
                      style: DSTypography.headline.copyWith(
                        fontWeight: FontWeight.w700,
                        color: DSColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.tune_rounded,
                        color: DSColors.textPrimary, size: 22),
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
                  color: DSColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: DSColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.radio_button_checked_rounded,
                        color: DSColors.success, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'Pune',
                      style: DSTypography.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: DSColors.textPrimary,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.arrow_forward_rounded,
                          color: DSColors.textTertiary, size: 14),
                    ),
                    const Icon(Icons.location_on_rounded,
                        color: DSColors.primary, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'Kolhapur',
                      style: DSTypography.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: DSColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 1,
                      height: 16,
                      color: DSColors.border,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Today',
                      style: DSTypography.caption.copyWith(
                        color: DSColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Edit',
                        style: DSTypography.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: DSColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: DSColors.primary,
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
  // FILTER BAR
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
            
            // Animated sort icon that rotates when a sort filter is applied
            Widget? sortIcon;
            if (i == 1 || i == 2) {
              sortIcon = AnimatedRotation(
                turns: active ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  Icons.arrow_downward_rounded,
                  size: 14,
                  color: active ? DSColors.primary : DSColors.textSecondary,
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: PremiumFilterChip(
                label: _filters[i],
                isSelected: active,
                icon: sortIcon,
                onTap: () {
                  setState(() => _activeFilter = i);
                },
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
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) => const SkeletonRouteCard(),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // RESULTS
  // ══════════════════════════════════════════════════════════════════
  Widget _buildResults(BuildContext context) {
    final allResults = [
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
        tagColor: DSColors.info,
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
        tagColor: DSColors.warning,
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

    // Filter & Sort logic
    List<_RideResult> results = List.from(allResults);
    final filterText = _filters[_activeFilter];
    if (filterText == '🚗 Car') {
      results = results.where((r) => r.vehicleType == 'Car').toList();
    } else if (filterText == '🛵 Bike') {
      results = results.where((r) => r.vehicleType == 'Bike').toList();
    } else if (filterText == 'Women Friendly') {
      results = results.where((r) => r.amenities.contains(Icons.female_rounded)).toList();
    } else if (filterText == 'AC') {
      results = results.where((r) => r.amenities.contains(Icons.ac_unit_rounded)).toList();
    } else if (filterText == 'Lowest Price') {
      results.sort((a, b) {
        final priceA = int.tryParse(a.price.replaceAll('₹', '')) ?? 0;
        final priceB = int.tryParse(b.price.replaceAll('₹', '')) ?? 0;
        return priceA.compareTo(priceB);
      });
    } else if (filterText == 'Earliest') {
      results.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    }

    if (results.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 100),
      itemCount: results.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, i) => _RideResultCard(
        result: results[i],
        onTap: () =>
            Navigator.pushNamed(context, AppRoutes.confirmRide),
        onBook: () =>
            Navigator.pushNamed(context, AppRoutes.confirmRide),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: DSColors.textTertiary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No trips match your filters',
              style: DSTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Try removing some filters or changing your search criteria.',
              style: DSTypography.body.copyWith(
                color: DSColors.textSecondary,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() => _activeFilter = 0);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: DSColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DSRadius.sm),
                ),
              ),
              child: const Text('Reset Filters'),
            ),
          ],
        ),
      ),
    );
  }
}

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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(DSRadius.card),
          boxShadow: DSShadows.elevation2,
          border: Border.all(color: DSColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driver row
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?u=${result.avatarSeed}'),
                  onBackgroundImageError: (exception, stackTrace) {},
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            result.driverName,
                            style: DSTypography.body.copyWith(
                              fontWeight: FontWeight.bold,
                              color: DSColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Row(
                            children: List.generate(
                              result.verificationLevel,
                              (i) => const Icon(Icons.verified_rounded,
                                  color: DSColors.info, size: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        result.vehicleInfo,
                        style: DSTypography.caption.copyWith(
                          color: DSColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Rating stars in clean gold
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: DSColors.warning, size: 16),
                    const SizedBox(width: 2),
                    Text(
                      result.rating,
                      style: DSTypography.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: DSColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Time & Price row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Time
                Row(
                  children: [
                    Text(
                      result.departureTime,
                      style: DSTypography.body.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: DSColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '-  ${result.duration}  -',
                      style: DSTypography.caption.copyWith(
                        color: DSColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      result.arrivalTime,
                      style: DSTypography.body.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: DSColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                // Price
                Text(
                  result.price,
                  style: DSTypography.titleLarge.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: DSColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Route detail
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    result.origin,
                    style: DSTypography.caption.copyWith(
                      color: DSColors.textTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    result.destination,
                    style: DSTypography.caption.copyWith(
                      color: DSColors.textTertiary,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: DSColors.divider),
            const SizedBox(height: 12),
            // Bottom row: Amenities, Seats, Tag, Book
            Row(
              children: [
                ...result.amenities.map(
                  (icon) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Icon(icon,
                        size: 16, color: DSColors.textMuted),
                  ),
                ),
                const Spacer(),
                if (result.tag.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: result.tagColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(DSRadius.xs),
                    ),
                    child: Text(
                      result.tag,
                      style: DSTypography.caption.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: result.tagColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  '${result.seatsAvailable} seats left',
                  style: DSTypography.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    color: DSColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: onBook,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(60, 32),
                      backgroundColor: DSColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(DSRadius.sm),
                      ),
                      elevation: 0,
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
          ],
        ),
      ),
    );
  }
}

