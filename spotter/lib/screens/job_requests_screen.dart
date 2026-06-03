import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../helper.dart';
import '../spotter_widgets.dart';
import 'driver_bottom_nav.dart';

class JobRequestsScreen extends StatelessWidget {
  const JobRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SpotterScreen(
      title: 'Route jobs',
      subtitle: 'Accept what fits your route.',
      showBack: false, // Hide back button since bottom nav is active
      bottomNavigationBar: const DriverBottomNav(activeTab: DriverBottomTab.requests),
      content: [
        _RequestCard(
          title: 'Baner to Koregaon Park',
          deviation: '1.2 km',
          payout: 'Rs 390',
          onTap: () => Navigator.pushNamed(context, AppRoutes.jobDetail),
        ),
        _RequestCard(
          title: 'Aundh to Camp',
          deviation: '5.1 km',
          payout: 'Rs 620',
          onTap: () => Navigator.pushNamed(context, AppRoutes.jobDetail),
        ),
        _RequestCard(
          title: 'Viman Nagar to Kalyani Nagar',
          deviation: '2.4 km',
          payout: 'Rs 260',
          onTap: () => Navigator.pushNamed(context, AppRoutes.jobDetail),
        ),
      ],
      bottom: const PrimaryAction(
        label: 'View best request',
        routeName: AppRoutes.jobDetail,
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final String title;
  final String deviation;
  final String payout;
  final VoidCallback? onTap;

  const _RequestCard({
    required this.title,
    required this.deviation,
    required this.payout,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SpotterCard(
      onTap: onTap,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        InfoRow(label: 'Deviation', value: deviation),
        InfoRow(label: 'Payout', value: payout),
      ],
    );
  }
}
