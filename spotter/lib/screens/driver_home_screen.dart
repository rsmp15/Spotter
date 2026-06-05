import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/app_routes.dart';
import '../core/components/status_chip.dart';
import '../core/components/spott_buttons.dart';
import '../core/components/spott_avatar.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../core/theme/radius.dart';
import '../core/theme/shadows.dart';
import '../core/theme/redbus_theme.dart';
import '../core/components/redbus_sections.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  bool _isTravelActive = false;
  String? _destination;
  bool _isRideStarted = false;

  int _completedTripsToday = 2;
  int _todayEarnings = 1240;

  static const List<String> _popularDestinations = [
    'Koregaon Park',
    'Baner',
    'Hinjawadi IT Park',
    'Viman Nagar',
    'Pune Airport',
  ];

  @override
  Widget build(BuildContext context) {
    if (_isRideStarted) {
      return _buildNavigationScreen(context);
    }

    return Scaffold(
      backgroundColor: RBColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header Section
            SliverToBoxAdapter(
              child: RBSectionContainer(
                style: RBSectionStyle.brandHero,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: _buildHeader(),
              ),
            ),

            // Wave Separator
            SliverToBoxAdapter(
              child: RBWaveSeparator(
                topColor: RBColors.primary,
                bottomColor: RBColors.background,
                height: 24,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            if (_isTravelActive && _destination != null) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildDestinationFilterCard(context),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],

            // Earnings Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildEarningsCard(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Start Travel or Accepting Requests Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: !_isTravelActive
                    ? _buildStartTravelCard(context)
                    : _buildAcceptingRequestsCard(),
              ),
            ),

            // Spacing 48px
            const SliverToBoxAdapter(child: SizedBox(height: 48)),

            // Trip Requests nearby Section
            SliverToBoxAdapter(
              child: RBSectionContainer(
                style: RBSectionStyle.marketplace,
                topRadius: 28,
                bottomRadius: 28,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const RBSectionHeader(
                      title: 'Trip requests nearby',
                      subtitle: 'Active requests matching your route',
                    ),
                    const SizedBox(height: 8),
                    _buildTripRequestsCard(),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 48)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TRAVELER',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white70,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Arjun',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
          child: const SpottAvatar(
            imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704d',
            radius: 22,
            isVerified: true,
            isPremium: true,
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationFilterCard(BuildContext context) {
    return RBSectionContainer(
      style: RBSectionStyle.rewards,
      topRadius: 16,
      bottomRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: RBColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_rounded, color: RBColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Destination Filter Active',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: RBColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Accepting requests toward $_destination',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: RBColors.textMedium,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 20, color: RBColors.textLight),
            onPressed: () {
              setState(() {
                _isTravelActive = false;
                _destination = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsCard() {
    return RBSectionContainer(
      style: RBSectionStyle.white,
      showBorder: true,
      topRadius: 16,
      bottomRadius: 16,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Earnings this week',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: RBColors.textMedium,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '₹${_todayEarnings + 7210}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: RBColors.textDark,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: RBColors.primarySoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Today: ₹$_todayEarnings',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: RBColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildEarningsBar(),
          const SizedBox(height: 16),
          const Divider(height: 1, color: RBColors.divider),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatPill(
                icon: Icons.check_circle_rounded,
                value: '$_completedTripsToday',
                label: 'Trips',
                color: RBColors.green,
              ),
              _buildStatPill(
                icon: Icons.timer_rounded,
                value: '5h 12m',
                label: 'Online',
                color: RBColors.blue,
              ),
              _buildStatPill(
                icon: Icons.star_rounded,
                value: '4.95',
                label: 'Rating',
                color: RBColors.gold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsBar() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final values = [0.4, 0.7, 0.5, 0.9, 0.6, 0.3, 0.8];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(7, (i) {
        final isToday = i == DateTime.now().weekday - 1;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 48 * values[i],
              decoration: BoxDecoration(
                color: isToday ? RBColors.primary : RBColors.divider,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              days[i],
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                color: isToday ? RBColors.primary : RBColors.textMedium,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatPill({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: RBColors.textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: RBColors.textLight,
          ),
        ),
      ],
    );
  }

  Widget _buildStartTravelCard(BuildContext context) {
    return RBSectionContainer(
      style: RBSectionStyle.white,
      showBorder: true,
      topRadius: 16,
      bottomRadius: 16,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Earn on your trip',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: RBColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Accept seat requests matching your way and save on travel costs.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: RBColors.textMedium,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => _openLocationPicker(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: RBColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Start Travel',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptingRequestsCard() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              setState(() => _isRideStarted = true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Trip started heading toward $_destination!'),
                  backgroundColor: RBColors.seatAvailable,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: RBColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'ACCEPTING REQUESTS',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ready to travel to $_destination',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: RBColors.textMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildTripRequestsCard() {
    return RBSectionContainer(
      style: RBSectionStyle.white,
      topRadius: 16,
      bottomRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoRow('Best cost share', '₹650', RBColors.green),
          const Divider(height: 16, color: RBColors.divider),
          _buildInfoRow('Closest pickup', '1.2 km', RBColors.blue),
          const Divider(height: 16, color: RBColors.divider),
          _buildInfoRow('Seats requested', '2', RBColors.primary),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: RBColors.textMedium,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: valueColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: RBColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: RBColors.primarySoft,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.navigation_rounded, color: RBColors.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Active Trip',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: RBColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Traveling toward $_destination',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: RBColors.textMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: RBColors.divider),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.map_rounded, size: 48, color: RBColors.textLight),
                        SizedBox(height: 8),
                        Text(
                          'Map View',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: RBColors.textMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: RBSectionContainer(
                style: RBSectionStyle.white,
                showBorder: true,
                topRadius: 20,
                bottomRadius: 20,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StatusChip(label: 'ROUTE ACTIVE', status: ChipStatus.verified),
                    const SizedBox(height: 14),
                    const Text(
                      'Arriving in 18 mins',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: RBColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Distance remaining: 6.4 km',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: RBColors.textMedium,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isRideStarted = false;
                                  _isTravelActive = false;
                                  _destination = null;
                                  _completedTripsToday += 1;
                                  _todayEarnings += 350;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Trip completed! Earnings updated.'),
                                    backgroundColor: RBColors.seatAvailable,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: RBColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'COMPLETE TRIP',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: RBColors.surfaceGrey,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: RBColors.divider),
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() => _isRideStarted = false);
                            },
                            icon: const Icon(Icons.pause_rounded, color: RBColors.primary, size: 20),
                          ),
                        ),
                      ],
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

  void _openLocationPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        final searchController = TextEditingController();

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  20 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Where are you heading?',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: RBColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: RBColors.surfaceGrey,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: RBColors.divider),
                      ),
                      child: TextField(
                        controller: searchController,
                        autofocus: true,
                        cursorColor: RBColors.primary,
                        decoration: const InputDecoration(
                          hintText: 'Enter destination...',
                          border: InputBorder.none,
                          icon: Icon(Icons.search_rounded, color: RBColors.textMedium),
                        ),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: RBColors.textDark,
                        ),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            Navigator.pop(sheetContext);
                            setState(() {
                              _isTravelActive = true;
                              _destination = value.trim();
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'POPULAR DESTINATIONS',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: RBColors.textLight,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _popularDestinations.map((dest) {
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            Navigator.pop(sheetContext);
                            setState(() {
                              _isTravelActive = true;
                              _destination = dest;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: RBColors.surfaceGrey,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: RBColors.divider),
                            ),
                            child: Text(
                              dest,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: RBColors.textDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
