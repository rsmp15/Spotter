import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../spotter_widgets.dart';
import '../core/theme/colors.dart';
import '../core/components/marketplace_card.dart';

enum _ActivityFilter { all, trips, parcels, parking }

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  _ActivityFilter _filter = _ActivityFilter.all;

  static const _items = [
    _ActivityItem(
      type: _ActivityFilter.trips,
      icon: Icons.directions_car_rounded,
      title: 'Ride to Airport',
      subtitle: 'Spott Prime',
      driver: 'Arjun Sharma',
      time: 'Yesterday • 8:45 AM',
      amount: '₹340',
      status: 'Completed',
      dateGroup: 'TODAY',
    ),
    _ActivityItem(
      type: _ActivityFilter.parcels,
      icon: Icons.inventory_2_rounded,
      title: 'Package Delivered',
      subtitle: 'Tracking #SPT9483',
      driver: 'Rahul Patil',
      time: '2 hrs ago',
      amount: '₹92',
      status: 'Delivered',
      dateGroup: 'TODAY',
    ),
    _ActivityItem(
      type: _ActivityFilter.parking,
      icon: Icons.local_parking_rounded,
      title: 'Parking Session',
      subtitle: '2h 15m Meter',
      time: 'Today • 2:30 PM',
      amount: '₹80',
      status: 'Completed',
      dateGroup: 'TODAY',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final visibleItems = _items
        .where((item) => _filter == _ActivityFilter.all || item.type == _filter)
        .toList();

    return SpotterScreen(
      title: 'Your activity',
      subtitle: '18 Trips • ₹314 Saved This Month',
      showBack: false,
      showMenu: true,
      content: [
        // 1. Hero Summary Section
        _buildHeroSummaryCard(),
        const SizedBox(height: 24),

        // 2. Statistics Bento Grid
        _buildBentoGrid(),
        const SizedBox(height: 24),

        // 3. Better Filter Chips
        _buildFilters(),
        const SizedBox(height: 24),

        // 4. Recent Activity List
        if (visibleItems.isNotEmpty) ...[
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: SpottColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visibleItems.length,
            itemBuilder: (context, index) {
              final item = visibleItems[index];
              final isLast = index == visibleItems.length - 1;
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Timeline Line Column
                    Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ), // Align with first line of card text
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _getAccentColor(item.type),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: isLast
                              ? const SizedBox.shrink()
                              : Container(width: 2, color: SpottColors.border),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: _ActivityTile(item: item),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ] else
          _buildEmptyState(),
        const SizedBox(height: 24),

        // 5. Monthly Insights Section
        _buildMonthlyInsightsSection(),
        const SizedBox(height: 24),

        // 6. Download Statement CTA
        _buildDownloadStatementCTA(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildHeroSummaryCard() {
    return MarketplaceCard(
      onTap: () {},
      borderRadius: 24,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: SpottColors.surface1,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: SpottColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'THIS MONTH',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: SpottColors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: SpottColors.successSoft,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up_rounded,
                        color: SpottColors.success,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Saved 12%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: SpottColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '18 Activities',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: SpottColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Trips, Parcels & Parking',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: SpottColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹2,460 spent',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: SpottColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(height: 1, color: SpottColors.divider),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MONEY SAVED',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: SpottColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '₹314',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: SpottColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 36, width: 1, color: SpottColors.border),
                const SizedBox(width: 24),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DISTANCE TRAVELED',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: SpottColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '248 KM',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: SpottColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _BentoCard(
                value: '18',
                label: 'Trips',
                icon: Icons.directions_car_rounded,
                iconColor: SpottColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _BentoCard(
                value: '5',
                label: 'Parcels',
                icon: Icons.inventory_2_rounded,
                iconColor: SpottColors.accentPurple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _BentoCard(
                value: '₹314',
                label: 'Savings',
                icon: Icons.savings_rounded,
                iconColor: SpottColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _BentoCard(
                value: '248 KM',
                label: 'Distance',
                icon: Icons.map_rounded,
                iconColor: SpottColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilters() {
    final filters = <_ActivityFilter, String>{
      _ActivityFilter.all: '🌍 All',
      _ActivityFilter.trips: '🚗 Trips',
      _ActivityFilter.parcels: '📦 Parcels',
      _ActivityFilter.parking: '🅿 Parking',
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final entry in filters.entries) ...[
            ChoiceChip(
              label: Text(entry.value),
              selected: _filter == entry.key,
              onSelected: (_) => setState(() => _filter = entry.key),
              backgroundColor: SpottColors.surface2,
              selectedColor: SpottColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide.none,
              ),
              labelStyle: TextStyle(
                color: _filter == entry.key
                    ? Colors.white
                    : SpottColors.textSecondary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildMonthlyInsightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Monthly Insights',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: SpottColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _PremiumCard(
          child: Column(
            children: [
              _buildInsightRow(
                icon: Icons.alt_route_rounded,
                iconColor: SpottColors.accentPurple,
                title: 'Most Used Route',
                value: 'Pune → Mumbai',
              ),
              const Divider(height: 24, color: SpottColors.divider),
              _buildInsightRow(
                icon: Icons.savings_outlined,
                iconColor: SpottColors.success,
                title: 'Saved Compared To Cab',
                value: '₹1,280',
              ),
              const Divider(height: 24, color: SpottColors.divider),
              _buildInsightRow(
                icon: Icons.explore_outlined,
                iconColor: SpottColors.warning,
                title: 'Distance Traveled',
                value: '248 km',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInsightRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: SpottColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: SpottColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadStatementCTA() {
    return MarketplaceCard(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Statement download started')),
        );
      },
      borderRadius: 24,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: SpottColors.surface1,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: SpottColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: SpottColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.download_rounded,
                color: SpottColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Download Statement',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: SpottColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'May 2026 PDF',
                    style: TextStyle(
                      fontSize: 12,
                      color: SpottColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: SpottColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: SpottColors.surface2,
              shape: BoxShape.circle,
            ),
            child: const Text('🧳', style: TextStyle(fontSize: 40)),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Trips Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: SpottColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Book your first ride or\nsend your first parcel.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: SpottColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.home),
            style: ElevatedButton.styleFrom(
              backgroundColor: SpottColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Explore Services',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Color _getAccentColor(_ActivityFilter type) {
    switch (type) {
      case _ActivityFilter.trips:
        return SpottColors.primary;
      case _ActivityFilter.parcels:
        return SpottColors.accentPurple;
      case _ActivityFilter.parking:
        return SpottColors.warning;
      case _ActivityFilter.all:
        return SpottColors.textPrimary;
    }
  }
}

class _ActivityTile extends StatelessWidget {
  final _ActivityItem item;

  const _ActivityTile({required this.item});

  @override
  Widget build(BuildContext context) {
    // Emojis based on type
    String typeEmoji = '';
    if (item.type == _ActivityFilter.trips) {
      typeEmoji = '🚗 ';
    } else if (item.type == _ActivityFilter.parcels) {
      typeEmoji = '📦 ';
    } else if (item.type == _ActivityFilter.parking) {
      typeEmoji = '🅿 ';
    }

    return _PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$typeEmoji${item.title}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: SpottColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.time,
                      style: const TextStyle(
                        color: SpottColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                item.amount,
                style: const TextStyle(
                  color: SpottColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (item.subtitle.isNotEmpty) ...[
            Text(
              item.subtitle,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: SpottColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
          ],
          if (item.driver != null) ...[
            Text(
              item.type == _ActivityFilter.parcels
                  ? 'Delivered by: ${item.driver}'
                  : 'Driver: ${item.driver}',
              style: const TextStyle(
                fontSize: 12,
                color: SpottColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusBgColor(item.status),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _getStatusTextColor(item.status),
                  ),
                ),
              ),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: SpottColors.border),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View Receipt',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: SpottColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: SpottColors.border),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Share',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: SpottColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusBgColor(String status) {
    if (status == 'Completed' || status == 'Delivered') {
      return SpottColors.successSoft;
    }
    return SpottColors.primarySoft;
  }

  Color _getStatusTextColor(String status) {
    if (status == 'Completed' || status == 'Delivered') {
      return SpottColors.success;
    }
    return SpottColors.primary;
  }
}

class _ActivityItem {
  final _ActivityFilter type;
  final IconData icon;
  final String title;
  final String subtitle;
  final String? driver;
  final String time;
  final String amount;
  final String status;
  final String dateGroup;

  const _ActivityItem({
    required this.type,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.driver,
    required this.time,
    required this.amount,
    required this.status,
    required this.dateGroup,
  });
}

class _BentoCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color iconColor;

  const _BentoCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SpottColors.surface1,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: SpottColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: SpottColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: SpottColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumCard extends StatelessWidget {
  final Widget child;

  const _PremiumCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SpottColors.surface1,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: SpottColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
