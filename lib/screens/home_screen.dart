import 'package:flutter/material.dart';
import 'package:spotter/app/app_routes.dart';
import 'package:spotter/custom_button.dart';
import 'package:spotter/custom_text_card.dart';
import 'package:spotter/helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.6,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Helper.mapFill,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(Icons.map, size: 90, color: Helper.muted),
                  ),
                  Positioned(
                    top: 18,
                    right: 18,
                    child: IconButton.filled(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.notifications),
                      icon: const Icon(Icons.notifications_outlined),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const CustomTextCard(
              horizontal: 15,
              children: [
                Text(
                  'Where To?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                Text(
                  'Search Destination',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const CustomTextCard(
              height: 210,
              horizontal: 15,
              children: [
                Text(
                  'Quick Destinations',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(thickness: 0.8, color: Colors.grey),
                Text(
                  'Home',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Koregaon Park, Pune',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                Divider(thickness: 0.8, color: Colors.grey),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomButton(
                routeName: AppRoutes.pickup,
                label: 'Book a ride',
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavIcon(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Wallet',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.wallet),
                  ),
                  _NavIcon(
                    icon: Icons.person_outline,
                    label: 'Profile',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.profile),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
