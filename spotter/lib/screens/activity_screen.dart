import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

enum ActivityFilter { all, trips, parcels }

class ActivityItem {
  final ActivityFilter type;
  final String title;
  final String startLocation;
  final String endLocation;
  final DateTime date;
  final double amount;
  final bool isCancelled;

  ActivityItem({
    required this.type,
    required this.title,
    required this.startLocation,
    required this.endLocation,
    required this.date,
    required this.amount,
    this.isCancelled = false,
  });
}

// Stitch specific trips:
// 1. Rajaji National Park Safari ($45.00)
// 2. Hotel Godawari ($12.50)
// 3. Package Delivery ($8.00)
final List<ActivityItem> _mockActivities = [
  ActivityItem(
    type: ActivityFilter.trips,
    title: 'Rajaji National Park Safari',
    startLocation: 'Near Cheela Dam',
    endLocation: 'Haridwar- Rishikesh',
    date: DateTime(2026, 6, 15, 14, 30),
    amount: 45.00,
  ),
  ActivityItem(
    type: ActivityFilter.trips,
    title: 'Hotel Godawari',
    startLocation: 'NH 58, Roorkee Cantonment',
    endLocation: 'Roorkee, Uttarakhand',
    date: DateTime(2026, 6, 12, 10, 15),
    amount: 12.50,
  ),
  ActivityItem(
    type: ActivityFilter.parcels,
    title: 'Package Delivery',
    startLocation: 'Office (WTC)',
    endLocation: 'Home',
    date: DateTime(2026, 6, 10, 16, 0),
    amount: 8.00,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F1114) : const Color(0xFFFAFBFC);
    final textColor = isDark ? const Color(0xFFF1F3F4) : const Color(0xFF1A1D21);

    final filteredItems = _mockActivities.where((item) {
      if (_currentFilter == ActivityFilter.all) return true;
      if (_currentFilter == ActivityFilter.trips && item.type == ActivityFilter.trips) return true;
      if (_currentFilter == ActivityFilter.parcels && item.type == ActivityFilter.parcels) return true;
      return false;
    }).toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Bar H1 "Activity"
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Text(
                'Activity',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  letterSpacing: -1.0,
                ),
              ),
            ),

            // Segment control pills (All | Rides | Parcels)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildSegmentButton(ActivityFilter.all, 'All Bookings', isDark),
                    const SizedBox(width: 8),
                    _buildSegmentButton(ActivityFilter.trips, 'Rides', isDark),
                    const SizedBox(width: 8),
                    _buildSegmentButton(ActivityFilter.parcels, 'Parcels', isDark),
                  ],
                ),
              ),
            ),

            // Section: "Past"
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                'Past',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Trip list or empty state
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.calendar_today,
                            size: 48,
                            color: isDark ? const Color(0xFF2D3239) : const Color(0xFFE8EAED),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No bookings found',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark ? const Color(0xFFAEB6BD) : const Color(0xFF5F6368),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
                      itemCount: filteredItems.length,
                      separatorBuilder: (context, index) => Divider(
                        color: isDark ? const Color(0xFF2D3239) : const Color(0xFFE8EAED),
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        return _ActivityRow(item: filteredItems[index], isDark: isDark);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentButton(ActivityFilter filter, String label, bool isDark) {
    final isSelected = _currentFilter == filter;
    final activeBg = isDark ? Colors.white : Colors.black;
    final activeText = isDark ? Colors.black : Colors.white;
    final inactiveBg = isDark ? const Color(0xFF222222) : const Color(0xFFF3F3F3);
    final inactiveText = isDark ? const Color(0xFFAFAFAF) : const Color(0xFF545454);

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentFilter = filter;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : inactiveBg,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: isSelected ? activeText : inactiveText,
          ),
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final ActivityItem item;
  final bool isDark;

  const _ActivityRow({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? const Color(0xFFAFAFAF) : const Color(0xFF545454);
    final isCancelled = item.isCancelled;

    IconData icon;
    if (item.type == ActivityFilter.trips) {
      icon = CupertinoIcons.car_detailed;
    } else {
      icon = CupertinoIcons.cube_box;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Uber grey square icon container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF222222) : const Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: textColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Center: Trip name/details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(item.date),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: subTextColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.location_solid,
                          size: 12,
                          color: subTextColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${item.startLocation} → ${item.endLocation}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: subTextColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // More details like Driver, Vehicle info to increase density:
                    Text(
                      item.type == ActivityFilter.trips 
                          ? 'Driver: Arjun Sharma • White Hyundai i20'
                          : 'Courier: Express Delivery • ID: #SP-8302',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: subTextColor.withValues(alpha: 0.8),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              // Right: Fare & Status
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${item.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: isCancelled ? subTextColor : textColor,
                      decoration: isCancelled ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isCancelled
                          ? const Color(0xFFFEE2E2)
                          : (isDark ? const Color(0xFF1E352F) : const Color(0xFFDCFCE7)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isCancelled ? 'Cancelled' : 'Completed',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: isCancelled 
                            ? const Color(0xFFE11900)
                            : (isDark ? const Color(0xFF66F2DF) : const Color(0xFF009E8A)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Actions block: Uber style Rebook & Details flat buttons
          Row(
            children: [
              const SizedBox(width: 52), // Align with text start
              if (!isCancelled) ...[
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? const Color(0xFF222222) : const Color(0xFFF3F3F3),
                    foregroundColor: textColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.arrow_counterclockwise, size: 12),
                      SizedBox(width: 6),
                      Text(
                        'Rebook',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: subTextColor,
                  side: BorderSide(
                    color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE2E2E2),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: const Text(
                  'Receipt',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final hour = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return 'Jun ${date.day} • $hour:$minute $period';
  }
}
