import 'package:flutter/material.dart';
import '../../theme/spott_theme.dart';
import '../../widgets/premium/glassmorphism.dart';
import '../../widgets/premium/service_chip.dart';
import '../../widgets/premium/community_banner.dart';
import '../../widgets/premium/premium_button.dart';
import 'premium_search_results_screen.dart';

class PremiumExploreScreen extends StatefulWidget {
  const PremiumExploreScreen({Key? key}) : super(key: key);

  @override
  State<PremiumExploreScreen> createState() => _PremiumExploreScreenState();
}

class _PremiumExploreScreenState extends State<PremiumExploreScreen> {
  int _selectedServiceIndex = 0;
  final List<String> _services = ['Trips', 'Parcels', 'Marketplace', 'Events'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpottTheme.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120), // Space for bottom nav
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildServiceSelector(),
              _buildSmartSearchCard(context),
              _buildSectionTitle("Trusted Communities"),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: SpottTheme.spacingLarge),
                child: CommunityBanner(),
              ),
              _buildSectionTitle("Quick Stats"),
              _buildQuickStats(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(SpottTheme.spacingLarge),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "Where are you going today?",
              style: SpottTheme.textTheme.displayMedium,
            ),
          ),
          const SizedBox(width: SpottTheme.spacingMedium),
          const CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSelector() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: SpottTheme.spacingLarge),
        scrollDirection: Axis.horizontal,
        itemCount: _services.length,
        separatorBuilder: (context, index) => const SizedBox(width: SpottTheme.spacingMedium),
        itemBuilder: (context, index) {
          return ServiceChip(
            label: _services[index],
            isSelected: _selectedServiceIndex == index,
            onTap: () {
              setState(() {
                _selectedServiceIndex = index;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildSmartSearchCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(SpottTheme.spacingLarge),
      child: Glassmorphism(
        padding: const EdgeInsets.all(SpottTheme.spacingLarge),
        child: Column(
          children: [
            _buildSearchField(
              icon: Icons.my_location,
              label: "From",
              placeholder: "Current Location",
              color: SpottTheme.primary,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Divider(color: SpottTheme.card, height: 24),
            ),
            _buildSearchField(
              icon: Icons.location_on,
              label: "To",
              placeholder: "Enter destination",
              color: SpottTheme.success,
            ),
            const SizedBox(height: SpottTheme.spacingLarge),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: SpottTheme.surface,
                      borderRadius: SpottTheme.borderRadiusMedium,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18, color: SpottTheme.textSecondary),
                        const SizedBox(width: 8),
                        Text("Today", style: SpottTheme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: SpottTheme.spacingMedium),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: SpottTheme.surface,
                      borderRadius: SpottTheme.borderRadiusMedium,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person, size: 18, color: SpottTheme.textSecondary),
                        const SizedBox(width: 8),
                        Text("1 Passenger", style: SpottTheme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: SpottTheme.spacingLarge),
            PremiumButton(
              text: "Search Rides",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PremiumSearchResultsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField({
    required IconData icon,
    required String label,
    required String placeholder,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: SpottTheme.spacingMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: SpottTheme.textTheme.labelMedium),
              const SizedBox(height: 4),
              Text(
                placeholder,
                style: SpottTheme.textTheme.titleMedium?.copyWith(
                  color: placeholder == "Current Location" ? Colors.white : SpottTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: SpottTheme.spacingLarge,
        right: SpottTheme.spacingLarge,
        top: SpottTheme.spacingLarge,
        bottom: SpottTheme.spacingMedium,
      ),
      child: Text(
        title,
        style: SpottTheme.textTheme.headlineMedium,
      ),
    );
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpottTheme.spacingLarge),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.5,
        children: [
          _buildStatCard("142", "Available Trips", Icons.route),
          _buildStatCard("38", "Parcel Requests", Icons.local_shipping),
          _buildStatCard("512", "Nearby Travelers", Icons.people),
          _buildStatCard("89", "Market Deals", Icons.storefront),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Glassmorphism(
      padding: const EdgeInsets.all(SpottTheme.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: SpottTheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                value,
                style: SpottTheme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: SpottTheme.textTheme.labelMedium?.copyWith(color: SpottTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
