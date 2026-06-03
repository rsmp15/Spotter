import 'package:flutter/material.dart';
import '../controllers/ride_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: Icon(Icons.arrow_back_rounded, color: isDark ? Colors.white : Colors.black),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.near_me_rounded, size: 20, color: isDark ? Colors.white : Colors.black),
                        const SizedBox(width: 6),
                        Text(
                          'SPOTT',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 32,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Account, vehicles, privacy, and preferences',
                  style: TextStyle(
                    color: isDark ? const Color(0xFFAFAFAF) : const Color(0xFF5E5E5E),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                const _SettingsRow(
                  icon: Icons.person_rounded,
                  title: 'Personal information',
                  detail: 'Name, phone, email',
                ),
                const _SettingsRow(
                  icon: Icons.directions_car_rounded,
                  title: 'Vehicles',
                  detail: 'My vehicles',
                ),
                const _SettingsRow(
                  icon: Icons.verified_user_rounded,
                  title: 'Verification status',
                  detail: 'KYC',
                ),
                const _SettingsRow(
                  icon: Icons.bookmark_rounded,
                  title: 'Saved places',
                  detail: 'Home, work',
                ),
                const _SettingsRow(
                  icon: Icons.notifications_rounded,
                  title: 'Notifications',
                  detail: 'Trips, safety',
                ),
                const _SettingsRow(
                  icon: Icons.privacy_tip_rounded,
                  title: 'Privacy',
                  detail: 'Location and account controls',
                ),
                _SettingsCard(
                  child: Row(
                    children: [
                      Icon(
                        isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        size: 28,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dark Theme',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isDark ? 'Dark mode active' : 'Light mode active',
                              style: const TextStyle(
                                color: Color(0xFF5E5E5E),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: isDark,
                        onChanged: (val) {
                          ride.toggleDarkMode();
                        },
                        activeThumbColor: isDark ? Colors.black : Colors.white,
                        activeTrackColor: isDark ? Colors.white : Colors.black,
                        inactiveThumbColor: Colors.black,
                        inactiveTrackColor: const Color(0xFFEFEFEF),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;

  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _SettingsCard(
      child: Row(
        children: [
          Icon(icon, size: 28, color: isDark ? Colors.white : Colors.black),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: TextStyle(
                    color: isDark ? const Color(0xFFAFAFAF) : const Color(0xFF5E5E5E),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: isDark ? Colors.white54 : Colors.black54),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;

  const _SettingsCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E2E2),
        ),
      ),
      child: child,
    );
  }
}
