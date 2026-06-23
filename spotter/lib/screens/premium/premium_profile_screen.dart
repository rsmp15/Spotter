import 'package:flutter/material.dart';
import '../../theme/spott_theme.dart';
import '../../widgets/premium/glassmorphism.dart';
import '../../widgets/premium/trust_badge.dart';

class PremiumProfileScreen extends StatelessWidget {
  const PremiumProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpottTheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context),
            Padding(
              padding: const EdgeInsets.all(SpottTheme.spacingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsRow(),
                  const SizedBox(height: SpottTheme.spacingXLarge),
                  Text("Trust & Verification", style: SpottTheme.textTheme.titleLarge),
                  const SizedBox(height: SpottTheme.spacingMedium),
                  _buildVerificationSection(),
                  const SizedBox(height: SpottTheme.spacingXLarge),
                  Text("Settings", style: SpottTheme.textTheme.titleLarge),
                  const SizedBox(height: SpottTheme.spacingMedium),
                  _buildSettingsList(),
                  const SizedBox(height: 120), // Bottom nav spacing
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 250,
          decoration: const BoxDecoration(
            gradient: SpottTheme.darkGradient,
            image: DecorationImage(
              image: NetworkImage('https://picsum.photos/seed/cover/800/400'),
              fit: BoxFit.cover,
              opacity: 0.3,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Glassmorphism(
              borderRadius: 24,
              padding: const EdgeInsets.all(12),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 16,
          child: Glassmorphism(
            borderRadius: 24,
            padding: const EdgeInsets.all(12),
            child: const Icon(Icons.edit, color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 150, left: SpottTheme.spacingLarge, right: SpottTheme.spacingLarge),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: SpottTheme.background, width: 4),
                  boxShadow: SpottTheme.premiumShadow,
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/300?u=a042581f4e29026704d'),
                ),
              ),
              const SizedBox(width: SpottTheme.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Rohan M.", style: SpottTheme.textTheme.headlineLarge),
                    const SizedBox(height: 4),
                    Text("Member since 2023", style: SpottTheme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Glassmorphism(
      padding: const EdgeInsets.all(SpottTheme.spacingLarge),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("4.9", "Rating", Icons.star, SpottTheme.warning),
          _buildStatItem("120", "Trips", Icons.route, SpottTheme.primary),
          _buildStatItem("8", "Communities", Icons.people, SpottTheme.success),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 4),
            Text(value, style: SpottTheme.textTheme.headlineMedium),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: SpottTheme.textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildVerificationSection() {
    return Glassmorphism(
      padding: const EdgeInsets.all(SpottTheme.spacingMedium),
      child: Column(
        children: [
          const ListTile(
            leading: TrustBadge(label: "Aadhaar", icon: Icons.verified),
            title: Text("Identity Verified", style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.check_circle, color: SpottTheme.success),
          ),
          const Divider(color: SpottTheme.card),
          const ListTile(
            leading: TrustBadge(label: "Driving License", icon: Icons.badge, color: SpottTheme.warning),
            title: Text("Driver Verified", style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.check_circle, color: SpottTheme.success),
          ),
          const Divider(color: SpottTheme.card),
          ListTile(
            leading: TrustBadge(label: "Corporate", icon: Icons.business, color: SpottTheme.textSecondary),
            title: const Text("Work Email", style: TextStyle(color: Colors.white)),
            trailing: TextButton(
              onPressed: () {},
              child: const Text("Verify Now", style: TextStyle(color: SpottTheme.primary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList() {
    return Glassmorphism(
      padding: const EdgeInsets.symmetric(vertical: SpottTheme.spacingSmall),
      child: Column(
        children: [
          _buildSettingsTile(Icons.person_outline, "Personal Information"),
          const Divider(color: SpottTheme.card, height: 1),
          _buildSettingsTile(Icons.directions_car_outlined, "Vehicles"),
          const Divider(color: SpottTheme.card, height: 1),
          _buildSettingsTile(Icons.payment, "Payment Methods"),
          const Divider(color: SpottTheme.card, height: 1),
          _buildSettingsTile(Icons.notifications_outlined, "Notifications"),
          const Divider(color: SpottTheme.card, height: 1),
          _buildSettingsTile(Icons.help_outline, "Help & Support"),
          const Divider(color: SpottTheme.card, height: 1),
          _buildSettingsTile(Icons.logout, "Log Out", color: SpottTheme.primary),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.white),
      title: Text(
        title,
        style: SpottTheme.textTheme.titleMedium?.copyWith(color: color ?? Colors.white),
      ),
      trailing: Icon(Icons.chevron_right, color: SpottTheme.textSecondary),
      onTap: () {},
    );
  }
}

