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
      backgroundColor: SpottColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(
            left: SpottSpacing.lg,
            right: SpottSpacing.lg,
            top: SpottSpacing.lg,
            bottom: SpottSpacing.pageBottom,
          ),
          children: [
            _buildHeader(),
            const SizedBox(height: SpottSpacing.xl),

            if (_isTravelActive && _destination != null) ...[
              _buildDestinationFilterCard(context),
              const SizedBox(height: SpottSpacing.md),
            ],

            _buildEarningsCard(),
            const SizedBox(height: SpottSpacing.xl),

            if (!_isTravelActive)
              _buildStartTravelCard(context)
            else
              _buildAcceptingRequestsCard(),

            const SizedBox(height: SpottSpacing.xl),

            const Text('Trip requests nearby', style: SpottTextStyles.headline),
            const SizedBox(height: SpottSpacing.md),
            _buildTripRequestsCard(),
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
            Text(
              'TRAVELER',
              style: SpottTextStyles.overline.copyWith(
                color: SpottColors.accentPurple,
              ),
            ),
            const SizedBox(height: 4),
            Text('Arjun', style: SpottTextStyles.headline.copyWith(fontSize: 26)),
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
    return _PremiumCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(SpottSpacing.sm),
            decoration: const BoxDecoration(
              color: SpottColors.accentPurpleSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_rounded, color: SpottColors.accentPurple, size: 20),
          ),
          const SizedBox(width: SpottSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Destination Filter Active',
                  style: SpottTextStyles.label.copyWith(
                    color: SpottColors.accentPurple,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Accepting requests toward $_destination',
                  style: SpottTextStyles.caption,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 20, color: SpottColors.textTertiary),
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
    return _PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Earnings this week', style: SpottTextStyles.caption),
                  const SizedBox(height: 6),
                  Text(
                    '₹${_todayEarnings + 7210}',
                    style: SpottTextStyles.displayLarge.copyWith(fontSize: 32),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpottSpacing.sm + 2,
                  vertical: SpottSpacing.xs + 2,
                ),
                decoration: BoxDecoration(
                  color: SpottColors.accentPurpleSoft,
                  borderRadius: BorderRadius.circular(SpottRadius.md),
                ),
                child: Text(
                  'Today: ₹$_todayEarnings',
                  style: SpottTextStyles.caption.copyWith(
                    color: SpottColors.accentPurple,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SpottSpacing.lg),
          _buildEarningsBar(),
          const SizedBox(height: SpottSpacing.lg),
          const Divider(height: 1, color: SpottColors.border),
          const SizedBox(height: SpottSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatPill(
                icon: Icons.check_circle_rounded,
                value: '$_completedTripsToday',
                label: 'Trips',
                color: SpottColors.success,
              ),
              _buildStatPill(
                icon: Icons.timer_rounded,
                value: '5h 12m',
                label: 'Online',
                color: SpottColors.info,
              ),
              _buildStatPill(
                icon: Icons.star_rounded,
                value: '4.95',
                label: 'Rating',
                color: SpottColors.warning,
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
                color: isToday ? SpottColors.accentPurple : SpottColors.border,
                borderRadius: BorderRadius.circular(SpottRadius.xs),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              days[i],
              style: SpottTextStyles.caption.copyWith(
                fontSize: 10,
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                color: isToday ? SpottColors.accentPurple : SpottColors.textSecondary,
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
              style: SpottTextStyles.label.copyWith(fontSize: 15),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: SpottTextStyles.caption),
      ],
    );
  }

  Widget _buildStartTravelCard(BuildContext context) {
    return _PremiumCard(
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Set destination travel', style: SpottTextStyles.titleSmall),
                SizedBox(height: 4),
                Text(
                  'Accept seat requests matching your way.',
                  style: SpottTextStyles.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: SpottSpacing.md),
          SpottButton.secondary(
            label: 'Start',
            onPressed: () => _openLocationPicker(context),
            size: SpottButtonSize.small,
            isFullWidth: false,
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptingRequestsCard() {
    return Column(
      children: [
        SpottButton.secondary(
          label: 'ACCEPTING REQUESTS',
          onPressed: () {
            setState(() => _isRideStarted = true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Trip started heading toward $_destination!'),
                backgroundColor: SpottColors.success,
              ),
            );
          },
        ),
        const SizedBox(height: SpottSpacing.sm),
        Text(
          'Ready to travel to $_destination',
          style: SpottTextStyles.caption,
        ),
      ],
    );
  }

  Widget _buildTripRequestsCard() {
    return _PremiumCard(
      child: Column(
        children: [
          _buildInfoRow('Best cost share', '₹650', SpottColors.success),
          const Divider(height: SpottSpacing.lg, color: SpottColors.border),
          _buildInfoRow('Closest pickup', '1.2 km', SpottColors.info),
          const Divider(height: SpottSpacing.lg, color: SpottColors.border),
          _buildInfoRow('Seats requested', '2', SpottColors.accentPurple),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: SpottTextStyles.body),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: valueColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(SpottRadius.xs),
          ),
          child: Text(
            value,
            style: SpottTextStyles.label.copyWith(color: valueColor),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: SpottColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(SpottSpacing.lg),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: SpottColors.accentPurpleSoft,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.navigation_rounded, color: SpottColors.accentPurple),
                  ),
                  const SizedBox(width: SpottSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Active Trip', style: SpottTextStyles.titleSmall),
                        const SizedBox(height: 4),
                        Text(
                          'Traveling toward $_destination',
                          style: SpottTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.lg),
                child: Container(
                  decoration: BoxDecoration(
                    color: SpottColors.surface1,
                    borderRadius: BorderRadius.circular(SpottRadius.card),
                    border: Border.all(color: SpottColors.border),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.map_rounded, size: 48, color: SpottColors.textTertiary),
                        const SizedBox(height: SpottSpacing.sm),
                        const Text('Map View', style: SpottTextStyles.caption),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(SpottSpacing.lg),
              child: _PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StatusChip(label: 'ROUTE ACTIVE', status: ChipStatus.verified),
                    const SizedBox(height: SpottSpacing.md),
                    const Text('Arriving in 18 mins', style: SpottTextStyles.title),
                    const SizedBox(height: 4),
                    const Text('Distance remaining: 6.4 km', style: SpottTextStyles.caption),
                    const SizedBox(height: SpottSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: SpottButton.secondary(
                            label: 'COMPLETE TRIP',
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
                                  backgroundColor: SpottColors.success,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: SpottSpacing.md),
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: SpottColors.surface2,
                            borderRadius: BorderRadius.circular(SpottRadius.pill),
                            border: Border.all(color: SpottColors.border),
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() => _isRideStarted = false);
                            },
                            icon: const Icon(Icons.pause_rounded, color: SpottColors.primary, size: 20),
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
      backgroundColor: SpottColors.surface1,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SpottRadius.xxl),
          topRight: Radius.circular(SpottRadius.xxl),
        ),
      ),
      builder: (sheetContext) {
        final searchController = TextEditingController();

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  SpottSpacing.lg,
                  0,
                  SpottSpacing.lg,
                  SpottSpacing.lg + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Where are you heading?', style: SpottTextStyles.title),
                    const SizedBox(height: SpottSpacing.md),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.md, vertical: 4),
                      decoration: BoxDecoration(
                        color: SpottColors.surface2,
                        borderRadius: BorderRadius.circular(SpottRadius.pill),
                        border: Border.all(color: SpottColors.border),
                      ),
                      child: TextField(
                        controller: searchController,
                        autofocus: true,
                        cursorColor: SpottColors.primary,
                        decoration: const InputDecoration(
                          hintText: 'Enter destination...',
                          border: InputBorder.none,
                          icon: Icon(Icons.search_rounded, color: SpottColors.textSecondary),
                        ),
                        style: SpottTextStyles.bodyLarge,
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
                    const SizedBox(height: SpottSpacing.lg),
                    Text(
                      'POPULAR DESTINATIONS',
                      style: SpottTextStyles.overline.copyWith(
                        color: SpottColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: SpottSpacing.md),
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
                              color: SpottColors.surface2,
                              borderRadius: BorderRadius.circular(SpottRadius.pill),
                              border: Border.all(color: SpottColors.border),
                            ),
                            child: Text(
                              dest,
                              style: SpottTextStyles.caption.copyWith(
                                color: SpottColors.textPrimary,
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

class _PremiumCard extends StatelessWidget {
  final Widget child;

  const _PremiumCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SpottSpacing.cardInner),
      decoration: BoxDecoration(
        color: SpottColors.surface1,
        borderRadius: BorderRadius.circular(SpottRadius.card),
        border: Border.all(color: SpottColors.border),
        boxShadow: SpottShadows.elevation1,
      ),
      child: child,
    );
  }
}
