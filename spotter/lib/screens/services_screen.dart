import 'package:flutter/material.dart';

import '../app/app_assets.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;
    final colors = _ServiceColors(isDark);

    final primaryServices = [
      _ServiceAction(
        title: 'Find Trip',
        subtitle: 'Search trips and share costs',
        assetPath: AppAssets.car,
        fallbackIcon: Icons.search_rounded,
        badge: 'Popular',
        onTap: () => Navigator.pushNamed(context, AppRoutes.destination),
      ),
      _ServiceAction(
        title: 'Offer Trip',
        subtitle: 'Share your route and earn',
        assetPath: AppAssets.carClock,
        fallbackIcon: Icons.add_road_rounded,
        onTap: () => Navigator.pushNamed(context, AppRoutes.createTrip),
      ),
      _ServiceAction(
        title: 'Send Parcel',
        subtitle: 'Ship via verified travelers',
        assetPath: AppAssets.parcel,
        fallbackIcon: Icons.inventory_2_rounded,
        onTap: () => Navigator.pushNamed(context, AppRoutes.parcelBooking),
      ),
      _ServiceAction(
        title: 'My Trips',
        subtitle: 'Past and upcoming trips',
        assetPath: AppAssets.calendar,
        fallbackIcon: Icons.history_rounded,
        onTap: () => Navigator.pushNamed(context, AppRoutes.activity),
      ),
    ];



    return Scaffold(
      backgroundColor: colors.background,
      drawer: const SpotterMenuDrawer(),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(colors: colors),
                    const SizedBox(height: 20),
                    _SearchCard(
                      colors: colors,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.destination),
                    ),
                    const SizedBox(height: 26),
                    _SectionHeader(
                      title: 'Travel and share',
                      actionLabel: 'History',
                      colors: colors,
                      onActionTap: () =>
                          Navigator.pushNamed(context, AppRoutes.activity),
                    ),
                    const SizedBox(height: 12),
                    _ServiceGrid(actions: primaryServices, colors: colors),
                    const SizedBox(height: 28),
                    _SectionHeader(title: 'Manage your trip', colors: colors),
                    const SizedBox(height: 12),
                    _UtilityRows(colors: colors),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final _ServiceColors colors;

  const _Header({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.menu_rounded, color: colors.text),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Services',
                style: TextStyle(
                  color: colors.text,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Share rides, send parcels, save money',
                style: TextStyle(
                  color: colors.subtleText,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          tooltip: 'Payments',
          onPressed: () => Navigator.pushNamed(context, AppRoutes.wallet),
          icon: const Icon(Icons.account_balance_wallet_rounded),
        ),
      ],
    );
  }
}

class _SearchCard extends StatelessWidget {
  final _ServiceColors colors;
  final VoidCallback onTap;

  const _SearchCard({required this.colors, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 116),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: colors.accent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Ready to go?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Find a trip and share travel costs',
                    style: TextStyle(
                      color: Color(0xFFE0E7FF),
                      fontSize: 13,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final _ServiceColors colors;

  const _SectionHeader({
    required this.title,
    required this.colors,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: colors.text,
              fontSize: 21,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onActionTap,
            child: Text(
              actionLabel!,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
      ],
    );
  }
}

class _ServiceGrid extends StatelessWidget {
  final List<_ServiceAction> actions;
  final _ServiceColors colors;

  const _ServiceGrid({required this.actions, required this.colors});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: actions.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.34,
      ),
      itemBuilder: (context, index) {
        return _ServiceCard(action: actions[index], colors: colors);
      },
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final _ServiceAction action;
  final _ServiceColors colors;

  const _ServiceCard({required this.action, required this.colors});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
        ),
        child: Stack(
          children: [
            if (action.badge != null)
              Positioned(
                top: 0,
                right: 0,
                child: _Badge(label: action.badge!, colors: colors),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ServiceImage(
                  assetPath: action.assetPath,
                  fallbackIcon: action.fallbackIcon,
                  size: 44,
                  iconColor: colors.icon,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      action.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.subtleText,
                        fontSize: 11,
                        height: 1.2,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



class _UtilityRows extends StatelessWidget {
  final _ServiceColors colors;

  const _UtilityRows({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ServiceRow(
          icon: Icons.account_balance_wallet_rounded,
          title: 'Payments',
          subtitle: 'Review payments and transactions',
          colors: colors,
          onTap: () => Navigator.pushNamed(context, AppRoutes.wallet),
        ),
        const SizedBox(height: 10),
        _ServiceRow(
          icon: Icons.shield_rounded,
          title: 'Safety toolkit',
          subtitle: 'Trip sharing, help, and support',
          colors: colors,
          onTap: () => Navigator.pushNamed(context, AppRoutes.safetyToolkit),
        ),
        const SizedBox(height: 10),
        _ServiceRow(
          icon: Icons.person_rounded,
          title: 'Account preferences',
          subtitle: 'Profile and settings',
          colors: colors,
          onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
        ),
      ],
    );
  }
}

class _ServiceRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final _ServiceColors colors;

  const _ServiceRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: colors.chip,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: colors.icon, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: colors.subtleText,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colors.subtleText),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final _ServiceColors colors;

  const _Badge({required this.label, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.warning,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ServiceImage extends StatelessWidget {
  final String assetPath;
  final IconData fallbackIcon;
  final double size;
  final Color iconColor;

  const _ServiceImage({
    required this.assetPath,
    required this.fallbackIcon,
    required this.size,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(fallbackIcon, size: size, color: iconColor);
      },
    );
  }
}

class _ServiceAction {
  final String title;
  final String subtitle;
  final String assetPath;
  final IconData fallbackIcon;
  final String? badge;
  final VoidCallback onTap;

  const _ServiceAction({
    required this.title,
    required this.subtitle,
    required this.assetPath,
    required this.fallbackIcon,
    required this.onTap,
    this.badge,
  });
}

class _ServiceColors {
  final bool isDark;

  const _ServiceColors(this.isDark);

  Color get background =>
      isDark ? Helper.darkBackground : Helper.backgroundColor;
  Color get card => isDark ? const Color(0xFF121212) : Colors.white;
  Color get text => isDark ? Colors.white : Helper.ink;
  Color get subtleText => isDark ? const Color(0xFF98A2B3) : Helper.muted;
  Color get border => isDark ? const Color(0xFF222530) : Helper.lineColor;
  Color get chip => isDark ? const Color(0xFF1E293B) : const Color(0xFFF2F4F7);
  Color get icon => isDark ? Colors.white : Helper.primary;
  Color get accent => isDark ? const Color(0xFF1F3EA8) : Helper.primary;
  Color get inverse => isDark ? const Color(0xFF1E293B) : Helper.ink;
  Color get warning => isDark ? const Color(0xFFFFB020) : Helper.warning;
}
