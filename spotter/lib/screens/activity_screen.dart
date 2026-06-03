import 'package:flutter/material.dart';

import '../app/app_assets.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

enum _ActivityFilter { all, rides, parking, packages }

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  _ActivityFilter _filter = _ActivityFilter.all;

  static const _items = [
    _ActivityItem(
      type: _ActivityFilter.parking,
      icon: Icons.local_parking_rounded,
      title: 'Downtown Garage',
      detail: 'Today, 2:30 PM • 2h 15m',
      amount: '- Rs 80',
      status: 'Completed',
      statusColor: Helper.success,
    ),
    _ActivityItem(
      type: _ActivityFilter.rides,
      icon: Icons.directions_car_rounded,
      assetPath: AppAssets.car,
      title: 'Ride to Airport',
      detail: 'Yesterday, 8:45 AM • Spott Prime',
      amount: '- Rs 340',
      status: 'Receipt ready',
      statusColor: Helper.primary,
    ),
    _ActivityItem(
      type: _ActivityFilter.packages,
      icon: Icons.inventory_2_rounded,
      assetPath: AppAssets.parcel,
      title: 'Package to Kalyani Nagar',
      detail: 'Oct 18, 5:10 PM • Delivered',
      amount: '- Rs 92',
      status: 'Delivered',
      statusColor: Helper.success,
    ),
    _ActivityItem(
      type: _ActivityFilter.parking,
      icon: Icons.local_parking_rounded,
      title: 'Market St. Meter',
      detail: 'Oct 12, 1:15 PM • 45m',
      amount: '- Rs 45',
      status: 'Completed',
      statusColor: Helper.success,
    ),
    _ActivityItem(
      type: _ActivityFilter.rides,
      icon: Icons.two_wheeler_rounded,
      assetPath: AppAssets.bike,
      title: 'Moto from Office',
      detail: 'Oct 10, 6:30 PM • Spott Moto',
      amount: '- Rs 118',
      status: 'Rated 5.0',
      statusColor: Helper.warning,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final visibleItems = _items
        .where((item) => _filter == _ActivityFilter.all || item.type == _filter)
        .toList();

    return SpotterScreen(
      title: 'Your activity',
      subtitle: 'Rides, parking, package requests, receipts, and support.',
      showBack: false,
      showMenu: true,
      content: [
        const SpotterCard(
          children: [
            StatusChip(label: 'This month'),
            SizedBox(height: 12),
            InfoRow(label: 'Trips and sessions', value: '18'),
            InfoRow(label: 'Total spend', value: 'Rs 2,460'),
            InfoRow(label: 'Savings applied', value: 'Rs 314'),
          ],
        ),
        _ActivityFilters(
          selected: _filter,
          onSelected: (filter) => setState(() => _filter = filter),
        ),
        for (final item in visibleItems) _ActivityTile(item: item),
        if (visibleItems.isEmpty)
          const SpotterCard(
            children: [
              Text(
                'No activity yet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 6),
              Text(
                'Completed rides, parking sessions, and package requests will appear here.',
                style: TextStyle(color: Helper.muted),
              ),
            ],
          ),
      ],
      bottom: PrimaryAction(
        label: 'Download monthly statement',
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Statement download started')),
        ),
      ),
    );
  }
}

class _ActivityFilters extends StatelessWidget {
  final _ActivityFilter selected;
  final ValueChanged<_ActivityFilter> onSelected;

  const _ActivityFilters({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filters = <_ActivityFilter, String>{
      _ActivityFilter.all: 'All',
      _ActivityFilter.rides: 'Rides',
      _ActivityFilter.parking: 'Parking',
      _ActivityFilter.packages: 'Packages',
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final entry in filters.entries) ...[
              ChoiceChip(
                label: Text(entry.value),
                selected: selected == entry.key,
                onSelected: (_) => onSelected(entry.key),
                backgroundColor: isDark ? const Color(0xFF1E293B) : Helper.canvasSoft,
                selectedColor: isDark ? Colors.white : Helper.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                  side: BorderSide.none,
                ),
                labelStyle: TextStyle(
                  color: selected == entry.key 
                      ? (isDark ? Colors.black : Colors.white) 
                      : (isDark ? Colors.white : Helper.ink),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final _ActivityItem item;

  const _ActivityTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return SpotterCard(
      onTap: () => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${item.title} receipt opened'))),
      children: [
        Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Helper.canvasSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: item.assetPath == null
                  ? Icon(item.icon, color: Helper.ink)
                  : Padding(
                      padding: const EdgeInsets.all(9),
                      child: Image.asset(
                        item.assetPath!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(item.icon, color: Helper.ink),
                      ),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.detail,
                    style: const TextStyle(
                      color: Helper.muted,
                      fontSize: 12,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  StatusChip(label: item.status),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              item.amount,
              style: const TextStyle(
                color: Helper.ink,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActivityItem {
  final _ActivityFilter type;
  final IconData icon;
  final String? assetPath;
  final String title;
  final String detail;
  final String amount;
  final String status;
  final Color statusColor;

  const _ActivityItem({
    required this.type,
    required this.icon,
    required this.title,
    required this.detail,
    required this.amount,
    required this.status,
    required this.statusColor,
    this.assetPath,
  });
}
