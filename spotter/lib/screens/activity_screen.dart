import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';




enum ActivityFilter { all, trips, parcels, parking }

enum ActivityStatus { completed, upcoming, cancelled, inTransit }



class ActivityItem {
  final ActivityFilter type;
  final String title;
  final String id; // PNR or Tracking ID
  final String startLocation;
  final String endLocation;
  final DateTime date;
  final double amount;
  final ActivityStatus status;
  final String? driverName;
  final String? vehicleInfo;

  ActivityItem({
    required this.type,
    required this.title,
    required this.id,
    required this.startLocation,
    required this.endLocation,
    required this.date,
    required this.amount,
    required this.status,
    this.driverName,
    this.vehicleInfo,
  });
}

final List<ActivityItem> _mockActivities = [
  ActivityItem(
    type: ActivityFilter.trips,
    title: 'Ride to Airport',
    id: 'PNR: 884X29',
    startLocation: 'Koregaon Park, Pune',
    endLocation: 'Pune International Airport',
    date: DateTime.now().subtract(const Duration(hours: 2)),
    amount: 340.00,
    status: ActivityStatus.completed,
    driverName: 'Arjun Sharma',
    vehicleInfo: 'MH 12 AB 1234',
  ),
  ActivityItem(
    type: ActivityFilter.parcels,
    title: 'Package to Kalyani Nagar',
    id: 'TRK: SPT94832',
    startLocation: 'Office (WTC)',
    endLocation: 'Home (Kalyani Nagar)',
    date: DateTime.now().subtract(const Duration(days: 1)),
    amount: 92.50,
    status: ActivityStatus.completed,
    driverName: 'Rahul Patil',
  ),
  ActivityItem(
    type: ActivityFilter.trips,
    title: 'Spott Intercity Bus',
    id: 'PNR: B55901',
    startLocation: 'Swargate, Pune',
    endLocation: 'Dadar, Mumbai',
    date: DateTime.now().add(const Duration(days: 2)),
    amount: 850.00,
    status: ActivityStatus.upcoming,
    vehicleInfo: 'Volvo Multi-Axle',
  ),
  ActivityItem(
    type: ActivityFilter.parking,
    title: 'Downtown Garage',
    id: 'TKT: PKG-221',
    startLocation: 'Phoenix Mall Level 2',
    endLocation: '3 Hours Duration',
    date: DateTime.now().subtract(const Duration(days: 3)),
    amount: 120.00,
    status: ActivityStatus.completed,
  ),
  ActivityItem(
    type: ActivityFilter.trips,
    title: 'Moto from Office',
    id: 'PNR: 112M8',
    startLocation: 'Viman Nagar',
    endLocation: 'Magarpatta City',
    date: DateTime.now().subtract(const Duration(days: 5)),
    amount: 85.00,
    status: ActivityStatus.cancelled,
    driverName: 'Karan Singh',
  ),
];

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  ActivityFilter _currentFilter = ActivityFilter.all;

  @override
  Widget build(BuildContext context) {
    final filteredItems = _mockActivities.where((item) {
      if (_currentFilter == ActivityFilter.all) return true;
      return item.type == _currentFilter;
    }).toList();

    return Scaffold(
      backgroundColor: DSColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildBentoStats(),
                  const SizedBox(height: 32),
                  _buildActionCards(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          _buildStickyHeader(),
          _buildActivityList(filteredItems),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40.0 + 72.0 + MediaQuery.of(context).padding.bottom,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: DSColors.surface,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        title: const Text(
          'Your activity',
          style: TextStyle(
            color: DSColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [DSColors.primarySoft, DSColors.surface],
              stops: [0.0, 0.4],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: DSColors.textPrimary),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Icons.help_outline_rounded,
            color: DSColors.textPrimary,
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBentoStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: DSColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Total Trips',
                value: '24',
                icon: Icons.route_rounded,
                color: DSColors.primary,
                trend: '+3 this month',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'Amount Saved',
                value: '₹840',
                icon: Icons.savings_rounded,
                color: DSColors.success,
                trend: 'Top 10% saver',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCards() {
    return Container(
      decoration: BoxDecoration(
        color: DSColors.surface,
        borderRadius: BorderRadius.circular(DSRadius.card),
        border: Border.all(color: DSColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(DSRadius.card),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: DSColors.primarySoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: DSColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Travel Statement',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: DSColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Download PDF for May 2026',
                        style: TextStyle(
                          fontSize: 13,
                          color: DSColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.download_rounded,
                  color: DSColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStickyHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _StickyFilterDelegate(
        child: Container(
          color: DSColors.background,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  ActivityFilter.all,
                  'All Bookings',
                  Icons.list_alt_rounded,
                ),
                _buildFilterChip(
                  ActivityFilter.trips,
                  'Rides',
                  Icons.directions_car_rounded,
                ),
                _buildFilterChip(
                  ActivityFilter.parcels,
                  'Parcels',
                  Icons.inventory_2_rounded,
                ),
                _buildFilterChip(
                  ActivityFilter.parking,
                  'Parking',
                  Icons.local_parking_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(ActivityFilter filter, String label, IconData icon) {
    final isSelected = _currentFilter == filter;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        selected: isSelected,
        showCheckmark: false,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : DSColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : DSColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
        backgroundColor: DSColors.surface,
        selectedColor: DSColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(
            color: isSelected ? DSColors.primary : DSColors.border,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        onSelected: (_) {
          setState(() => _currentFilter = filter);
        },
      ),
    );
  }

  Widget _buildActivityList(List<ActivityItem> items) {
    if (items.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 64,
                  color: DSColors.border,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No bookings found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: DSColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Try changing your filters',
                  style: TextStyle(color: DSColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _TicketCard(item: item),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final ActivityItem item;

  const _TicketCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DSColors.surface,
        borderRadius: BorderRadius.circular(DSRadius.card),
        border: Border.all(color: DSColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Section: Type & Status
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getTypeColor(item.type).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getTypeIcon(item.type),
                        size: 20,
                        color: _getTypeColor(item.type),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: DSColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.id,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: DSColors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                _StatusBadge(status: item.status),
              ],
            ),
          ),

          // Dashed Divider (Ticket effect)
          _buildDashedDivider(),

          // Middle Section: Route & Time
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildRouteVisual(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDate(item.date),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: DSColors.textPrimary,
                          ),
                        ),
                        Text(
                          _formatTime(item.date),
                          style: const TextStyle(
                            fontSize: 13,
                            color: DSColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${item.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: DSColors.textPrimary,
                          ),
                        ),
                        const Text(
                          'Paid',
                          style: TextStyle(
                            fontSize: 12,
                            color: DSColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Section: Actions
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: DSColors.border)),
              color: DSColors.surfaceVariant,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(DSRadius.card),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                if (item.status == ActivityStatus.upcoming) ...[
                  Expanded(
                    child: _buildActionButton(
                      'Track',
                      Icons.location_on_outlined,
                      DSColors.primary,
                    ),
                  ),
                  Expanded(
                    child: _buildActionButton(
                      'E-Ticket',
                      Icons.qr_code_rounded,
                      DSColors.textPrimary,
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: _buildActionButton(
                      'Support',
                      Icons.headset_mic_outlined,
                      DSColors.textPrimary,
                    ),
                  ),
                  Expanded(
                    child: _buildActionButton(
                      'Rebook',
                      Icons.refresh_rounded,
                      DSColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteVisual() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dots and Line
        Column(
          children: [
            const SizedBox(height: 4),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                border: Border.all(color: DSColors.textMuted, width: 2),
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            Container(width: 2, height: 24, color: DSColors.border),
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: DSColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        // Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.startLocation,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: DSColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 14),
              Text(
                item.endLocation,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: DSColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDashedDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          const dashWidth = 5.0;
          const dashHeight = 1.5;
          final dashCount = (boxWidth / (2 * dashWidth)).floor();
          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return const SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: DSColors.border),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color) {
    return TextButton.icon(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DSRadius.button),
        ),
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }

  IconData _getTypeIcon(ActivityFilter type) {
    switch (type) {
      case ActivityFilter.trips:
        return Icons.directions_bus_rounded; // Changed to Bus for RedBus feel
      case ActivityFilter.parcels:
        return Icons.local_shipping_rounded;
      case ActivityFilter.parking:
        return Icons.local_parking_rounded;
      default:
        return Icons.receipt_rounded;
    }
  }

  Color _getTypeColor(ActivityFilter type) {
    switch (type) {
      case ActivityFilter.trips:
        return DSColors.primary;
      case ActivityFilter.parcels:
        return Color(0xFF8E24AA);
      case ActivityFilter.parking:
        return DSColors.warning;
      default:
        return DSColors.textPrimary;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour == 0
        ? 12
        : (date.hour > 12 ? date.hour - 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}

class _StatusBadge extends StatelessWidget {
  final ActivityStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String text;

    switch (status) {
      case ActivityStatus.completed:
        bgColor = DSColors.successSoft;
        textColor = DSColors.success;
        text = 'COMPLETED';
        break;
      case ActivityStatus.upcoming:
        bgColor = DSColors.infoSoft;
        textColor = DSColors.info;
        text = 'UPCOMING';
        break;
      case ActivityStatus.cancelled:
        bgColor = DSColors.warningSoft;
        textColor = DSColors.warning;
        text = 'CANCELLED';
        break;
      case ActivityStatus.inTransit:
        bgColor = DSColors.primarySoft;
        textColor = DSColors.primary;
        text = 'IN TRANSIT';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(DSRadius.sm),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DSColors.surface,
        borderRadius: BorderRadius.circular(DSRadius.card),
        border: Border.all(color: DSColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: DSColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: DSColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            trend,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// Delegate to allow the filter header to stick to the top during scroll
class _StickyFilterDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyFilterDelegate({required this.child});

  @override
  double get minExtent => 60.0;
  @override
  double get maxExtent => 60.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: maxExtent,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: DSColors.background,
        boxShadow: overlapsContent
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }

  @override
  bool shouldRebuild(_StickyFilterDelegate oldDelegate) => true;
}
