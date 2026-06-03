import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class SafetyToolkitScreen extends StatelessWidget {
  const SafetyToolkitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;

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
                onPressed: () => Navigator.pop(context),
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
            // Hero Section: Emergency Assistance
            Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECEB),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Helper.danger.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.emergency_share_rounded,
                    color: Helper.danger,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Emergency Assistance',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'If you are in immediate danger, contact local emergency services right away.',
                  style: TextStyle(
                    color: Helper.muted,
                    fontSize: 15,
                    height: 1.35,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Primary Call Buttons
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
              icon: const Icon(Icons.call_rounded),
              onPressed: () => _showSafetyMessage(context, 'Calling emergency help (112)'),
              label: const Text(
                'Call 112 / 911',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Helper.canvasSoft,
                foregroundColor: isDark ? Colors.white : Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.share_rounded),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.shareTrip),
              label: const Text(
                'Share Trip Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Current Ride Context Card (if active)
            RideContextCard(
              route: ride.routeLabel,
              fare: ride.fareLabel,
              driver: ride.selectedDriver?.name ?? 'Matching',
              status: ride.status.name,
            ),
            const SizedBox(height: 16),

            // Safety Tools list title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Text(
                'SAFETY TOOLS',
                style: TextStyle(
                  color: Helper.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 4),

            // Safety items list
            _SafetyActionCard(
              icon: Icons.shield_rounded,
              title: 'Safety Toolkit',
              subtitle: 'Access all safety features in one place',
              onTap: () => Navigator.pushNamed(context, AppRoutes.shareTrip),
            ),
            const SizedBox(height: 10),
            _SafetyActionCard(
              icon: Icons.report_rounded,
              title: 'Report an Issue',
              subtitle: 'Tell us if you felt unsafe during a ride',
              onTap: () => Navigator.pushNamed(context, AppRoutes.dispute),
            ),
            const SizedBox(height: 10),
            _SafetyActionCard(
              icon: Icons.group_rounded,
              title: 'Trusted Contacts',
              subtitle: 'Manage people who receive your status',
              onTap: () => _showSafetyMessage(context, 'Trusted contacts opened'),
            ),
            const SizedBox(height: 10),
            _SafetyActionCard(
              icon: Icons.support_agent_rounded,
              title: 'Contact support',
              subtitle: 'Get help from the safety and support team',
              onTap: () => Navigator.pushNamed(context, AppRoutes.support),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showSafetyMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _SafetyActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SafetyActionCard({
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
        padding: const EdgeInsets.all(16),
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
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Helper.muted,
                      fontSize: 13,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.chevron_right_rounded,
              color: Helper.muted,
            ),
          ],
        ),
      ),
    );
  }
}
