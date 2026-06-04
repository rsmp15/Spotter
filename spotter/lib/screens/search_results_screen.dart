import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../app/app_routes.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/route_card.dart';
import '../core/components/skeleton_route_card.dart';
import '../core/components/staggered_list.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../core/theme/radius.dart';
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

  @override
  void initState() {
    super.initState();
    // Simulate progressive network skeleton loading (Uber/Airbnb style)
    _loadingTimer = Timer(const Duration(milliseconds: 750), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: SpottColors.textPrimary),
        title: Text(_isLoading ? 'Searching...' : '3 rides found', style: SpottTextStyles.titleSmall),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.pageHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: SpottSpacing.sm),

            // ── Route Summary Pill ──────────────────────────────
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpottSpacing.lg,
                  vertical: SpottSpacing.sm + 2,
                ),
                decoration: BoxDecoration(
                  color: SpottColors.surface2,
                  borderRadius: BorderRadius.circular(SpottRadius.pill),
                  border: Border.all(color: SpottColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: SpottColors.accentPurple,
                      ),
                    ),
                    const SizedBox(width: SpottSpacing.sm),
                    Text(
                      'Pune',
                      style: SpottTextStyles.label.copyWith(fontSize: 13),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.sm),
                      child: Container(
                        width: 24,
                        height: 1.5,
                        color: SpottColors.border,
                      ),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: SpottColors.primary,
                      ),
                    ),
                    const SizedBox(width: SpottSpacing.sm),
                    Text(
                      'Kolhapur',
                      style: SpottTextStyles.label.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: SpottSpacing.lg),

            // ── Filter Chips ────────────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isActive: _activeFilter == 0,
                    onTap: () => setState(() => _activeFilter = 0),
                  ),
                  const SizedBox(width: SpottSpacing.sm),
                  _FilterChip(
                    label: '🚗 Car',
                    isActive: _activeFilter == 1,
                    onTap: () => setState(() => _activeFilter = 1),
                  ),
                  const SizedBox(width: SpottSpacing.sm),
                  _FilterChip(
                    label: '🛵 Bike',
                    isActive: _activeFilter == 2,
                    onTap: () => setState(() => _activeFilter = 2),
                  ),
                  const SizedBox(width: SpottSpacing.sm),
                  _FilterChip(
                    label: 'Women Friendly',
                    isActive: _activeFilter == 3,
                    onTap: () => setState(() => _activeFilter = 3),
                  ),
                  const SizedBox(width: SpottSpacing.sm),
                  _FilterChip(
                    label: 'AC',
                    isActive: _activeFilter == 4,
                    onTap: () => setState(() => _activeFilter = 4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: SpottSpacing.xl),

            // ── Result Cards or Skeletons ───────────────────────
            if (_isLoading)
              StaggeredList(
                children: const [
                  SkeletonRouteCard(),
                  SizedBox(height: SpottSpacing.md),
                  SkeletonRouteCard(),
                  SizedBox(height: SpottSpacing.md),
                  SkeletonRouteCard(),
                ],
              )
            else
              StaggeredList(
                children: [
                  RouteCard(
                    origin: 'Deccan Gymkhana, Pune',
                    destination: 'Central Bus Stand, Kolhapur',
                    driverName: 'Arjun K.',
                    driverAvatar: 'https://i.pravatar.cc/150?u=a042581f4e29026704a',
                    rating: '4.9',
                    costShare: '₹850',
                    seatsAvailable: 2,
                    departureTime: '7:30 AM',
                    vehicleType: 'Car',
                    tripCount: 542,
                    seatsFilled: 10,
                    totalSeats: 12,
                    viewsToday: 18,
                    demandTag: 'High Demand',
                    verificationLevel: 4,
                    safetyScore: 98,
                    responseRate: 98,
                    cancellationRate: 0.4,
                    memberSince: 2023,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.confirmRide),
                  ),
                  RouteCard(
                    origin: 'Swargate, Pune',
                    destination: 'Mahalaxmi Temple, Kolhapur',
                    driverName: 'Priya M.',
                    driverAvatar: 'https://i.pravatar.cc/150?u=a042581f4e29026704b',
                    rating: '4.7',
                    costShare: '₹700',
                    seatsAvailable: 1,
                    departureTime: '9:15 AM',
                    vehicleType: 'Car',
                    tripCount: 120,
                    seatsFilled: 3,
                    totalSeats: 4,
                    viewsToday: 9,
                    demandTag: 'Only 1 seat left',
                    verificationLevel: 3,
                    safetyScore: 96,
                    responseRate: 95,
                    cancellationRate: 0.8,
                    memberSince: 2023,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.confirmRide),
                  ),
                  RouteCard(
                    origin: 'Hinjewadi, Pune',
                    destination: 'Shiroli, Kolhapur',
                    driverName: 'Ravi S.',
                    driverAvatar: 'https://i.pravatar.cc/150?u=a042581f4e29026704c',
                    rating: '4.6',
                    costShare: '₹950',
                    seatsAvailable: 3,
                    departureTime: '11:00 AM',
                    vehicleType: 'Car',
                    tripCount: 47,
                    seatsFilled: 1,
                    totalSeats: 4,
                    viewsToday: 5,
                    verificationLevel: 2,
                    safetyScore: 92,
                    responseRate: 90,
                    cancellationRate: 1.2,
                    memberSince: 2024,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.confirmRide),
                  ),
                ],
              ),

            const SizedBox(height: SpottSpacing.pageBottom),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: SpottAnimations.fast,
        curve: SpottCurves.emphasized,
        padding: const EdgeInsets.symmetric(
          horizontal: SpottSpacing.md,
          vertical: SpottSpacing.sm + 2,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? SpottColors.primarySoft
              : SpottColors.surface3,
          borderRadius: BorderRadius.circular(SpottRadius.pill),
          border: Border.all(
            color: isActive
                ? SpottColors.primary.withValues(alpha: 0.4)
                : SpottColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? SpottColors.primary : SpottColors.textSecondary,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}
