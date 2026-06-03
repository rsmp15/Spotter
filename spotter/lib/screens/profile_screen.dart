import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const SpotterMenuDrawer(),
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
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          }
        ),
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
            // Profile Header Section
            Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: isDark ? Colors.white : Colors.black, width: 2),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuBYc2FtWVRcfQugKIsBU8_RfEGogmOWZpavLDRbN1G02CRFD4kL9ygcqh1xJpzNOmlkPOJXVkU6LrzjpYn-aHHZv8bSPss2v4JqiQZU2lBLf8YHGmwCo5p5htLHkhjlJx_W4lzDShiFkhyB_OGQkmWd5j-l8rjAwVQGUkLkqwQ9JmAO7KS0aXZGwT47XpKrfUS_NZWx06VYLmu83OPeexAPyyAsFi5tmijuNgDvkkhSkniVDWtBBbtlh81Ra2vcd5spguhZgcGOZQVt',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Demo User',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Helper.canvasSoft,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: isDark ? const Color(0xFFFACC15) : Colors.black,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '4.92',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            const SizedBox(height: 24),

            // Account Settings List
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF121212) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Helper.line(context)),
              ),
              child: Column(
                children: [
                  _ProfileItemTile(
                    icon: Icons.person_rounded,
                    title: 'Personal Information',
                    subtitle: 'Email, Phone, Password',
                    onTap: () => _showProfileMessage(context, 'Personal info opened'),
                  ),
                  const Divider(height: 1, indent: 64),
                  _ProfileItemTile(
                    icon: Icons.directions_car_rounded,
                    title: 'My Vehicles',
                    subtitle: 'Registered vehicles for trips',
                    onTap: () => _showProfileMessage(context, 'My vehicles opened'),
                  ),
                  const Divider(height: 1, indent: 64),
                  _ProfileItemTile(
                    icon: Icons.verified_user_rounded,
                    title: 'Verification Status',
                    subtitle: 'ID, License, Vehicle docs',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.kyc),
                  ),
                  const Divider(height: 1, indent: 64),
                  _ProfileItemTile(
                    icon: Icons.history_rounded,
                    title: 'Trip History',
                    subtitle: 'Past trips and receipts',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.activity),
                  ),
                  const Divider(height: 1, indent: 64),
                  _ProfileItemTile(
                    icon: Icons.bookmark_rounded, // consistent key icon or similar
                    title: 'Safety Toolkit',
                    subtitle: 'Trusted contacts and sharing',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.safetyToolkit),
                  ),
                  const Divider(height: 1, indent: 64),
                  _ProfileItemTile(
                    icon: Icons.support_agent_rounded,
                    title: 'Help Center',
                    subtitle: 'Support cases and reports',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.support),
                  ),
                  const Divider(height: 1, indent: 64),
                  _ProfileItemTile(
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    subtitle: 'App preferences, Privacy',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Logout Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF1E293B) : Helper.canvasSoft,
                foregroundColor: isDark ? Colors.white : Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 0,
              ),
              onPressed: () => _showProfileMessage(context, 'Logged out'),
              child: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showProfileMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _ProfileItemTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileItemTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Helper.canvasSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isDark ? Colors.white : Colors.black, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Helper.mutedColor(context),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: Helper.mutedColor(context),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
