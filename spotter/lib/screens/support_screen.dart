import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../models/production_readiness_models.dart';
import '../spotter_widgets.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;

    final supportCase = SupportCase.forRide(
      rideReference: ride.shareLink.split('/').last.isNotEmpty
          ? ride.shareLink.split('/').last
          : 'SPT2049',
      role: UserRole.rider,
      category: SupportCaseCategory.technical,
      description: 'Help request from ride flow',
    );

    return Scaffold(
      backgroundColor: Helper.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'SPOTT',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (route) => false,
                ),
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_rounded),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications opened')),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // Heading: How can we help?
            const SizedBox(height: 12),
            const Text(
              'How can we help?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Help center',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Helper.muted,
              ),
            ),
            const SizedBox(height: 16),

            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Helper.canvasSofter,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search_rounded, color: Helper.muted),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Search for help topics',
                      style: TextStyle(color: Helper.muted, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recent Case details (needed for widget tests!)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Helper.lineColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Helper.canvasSoft,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Recent case',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _CaseInfoRow(
                    label: 'Ride reference',
                    value: supportCase.rideReference,
                  ),
                  const Divider(height: 20),
                  _CaseInfoRow(label: 'Role', value: supportCase.roleLabel),
                  const Divider(height: 20),
                  _CaseInfoRow(
                    label: 'Issue category',
                    value: supportCase.categoryLabel,
                  ),
                  const Divider(height: 20),
                  _CaseInfoRow(
                    label: 'Status',
                    value: supportCase.statusLabel,
                    valueColor: isDark ? Colors.white : Colors.black,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Popular Topics Bento-ish Section
            const Text(
              'Popular Topics',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 4.5,
              mainAxisSpacing: 10,
              children: [
                _SupportTopicBentoCard(
                  icon: Icons.directions_car_rounded,
                  title: 'Ride Issues',
                  subtitle: 'Report a problem with a recent trip or driver.',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.dispute),
                ),
                _SupportTopicBentoCard(
                  icon: Icons.credit_card_rounded,
                  title: 'Payments & Charges',
                  subtitle:
                      'Review receipts, dispute charges, or update billing.',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.dispute),
                ),
                _SupportTopicBentoCard(
                  icon: Icons.security_rounded,
                  title: 'Safety',
                  subtitle:
                      'Report an incident, share feedback, or access safety tools.',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.safetyToolkit),
                ),
                _SupportTopicBentoCard(
                  icon: Icons.manage_accounts_rounded,
                  title: 'Account & App',
                  subtitle:
                      'Manage profile settings, passwords, and app performance.',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                ),
                _SupportTopicBentoCard(
                  icon: Icons.electric_scooter_rounded,
                  title: 'Micromobility',
                  subtitle: 'Help with bikes, scooters, and parking zones.',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.parking),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Recent trip section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Help with a recent trip',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                TextButton(
                  onPressed: () =>
                      _showSupportMessage(context, 'All trips opened'),
                  child: const Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Helper.muted,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            InkWell(
              onTap: () => Navigator.pushNamed(context, AppRoutes.dispute),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Helper.canvasSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.map_rounded,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Oct 24 • 2:15 PM',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'To: 124 Main St. • \$14.50',
                            style: TextStyle(color: Helper.muted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Helper.muted,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Contact Support Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.white : Colors.black,
                foregroundColor: isDark ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.support_agent_rounded),
              onPressed: () =>
                  _showSupportMessage(context, 'Support chat started'),
              label: const Text(
                'Contact Support',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showSupportMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _CaseInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _CaseInfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Helper.muted,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _SupportTopicBentoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SupportTopicBentoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Helper.canvasSoft,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.black, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Helper.muted, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right_rounded,
              color: Helper.muted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
