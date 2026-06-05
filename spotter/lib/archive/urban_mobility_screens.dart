import 'package:flutter/material.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';

class ParkingScreen extends StatelessWidget {
  const ParkingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _UrbanScreen(
      title: 'Find Parking',
      subtitle: 'Nearby slots with live availability',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ParkingMap(),
          SizedBox(height: 18),
          _SearchPill(label: 'Search parking near destination'),
          SizedBox(height: 18),
          _VehicleFilterRow(labels: ['Car', 'Bike', 'Scooter', 'Auto']),
          SizedBox(height: 18),
          _ParkingSpotCard(
            title: 'Downtown Garage',
            detail: '0.2 miles away • 45 spots left',
            price: '\$4/hr',
            badge: 'Best value',
            imagePath: 'Car.png',
          ),
          _ParkingSpotCard(
            title: 'Market St. Meter',
            detail: '0.4 miles away • 12 spots left',
            price: '\$2/hr',
            badge: 'Street',
            imagePath: 'Rikshaw.png',
          ),
          _ParkingSpotCard(
            title: 'Central Station Deck',
            detail: '0.7 miles away • 28 spots left',
            price: '\$5/hr',
            badge: 'Covered',
            imagePath: 'Bike.png',
          ),
        ],
      ),
    );
  }
}

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _UrbanScreen(
      title: 'Coupons & Offers',
      subtitle: 'Available discounts for your next ride or park',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OfferHero(),
          SizedBox(height: 18),
          _VehicleFilterRow(labels: ['Rides', 'Parking', 'Scooter']),
          SizedBox(height: 18),
          _OfferCard(
            icon: Icons.local_taxi_rounded,
            label: 'Code: SPOTT20',
            title: '20% Off Next Ride',
            detail: 'Get 20% off your next ride within city limits.',
            action: 'Apply',
          ),
          _OfferCard(
            icon: Icons.local_parking_rounded,
            label: 'Auto-applied',
            title: '\$5 SAVED',
            detail: 'Save \$5 on weekend downtown parking sessions.',
            action: 'Apply',
          ),
          _OfferCard(
            icon: Icons.two_wheeler_rounded,
            label: 'Code: SCOOTFREE',
            title: 'Free Unlock',
            detail: 'Waive the unlock fee on your next scooter rentals.',
            action: 'Apply',
          ),
        ],
      ),
    );
  }
}

class ScheduleRideScreen extends StatelessWidget {
  const ScheduleRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _UrbanScreen(
      title: 'Schedule Ride',
      subtitle: 'Book your transport in advance',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LocationStack(),
          SizedBox(height: 20),
          _SectionLabel('Select Date'),
          SizedBox(height: 12),
          _DateChipRow(),
          SizedBox(height: 20),
          _SectionLabel('Select Time'),
          SizedBox(height: 12),
          _TimeGrid(),
          SizedBox(height: 24),
          _PrimaryBlackButton(label: 'Schedule Ride'),
        ],
      ),
    );
  }
}

class IntercityScreen extends StatelessWidget {
  const IntercityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _UrbanScreen(
      title: 'Intercity (Outstation)',
      subtitle: 'One-way and round-trip travel between cities',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SegmentedControl(labels: ['One Way', 'Round Trip']),
          SizedBox(height: 18),
          _LocationStack(),
          SizedBox(height: 18),
          _ScheduleRow(),
          SizedBox(height: 20),
          _SectionLabel('Select Vehicle'),
          SizedBox(height: 12),
          _VehicleOption(
            icon: Icons.directions_car_rounded,
            title: 'Intercity Mini',
            subtitle: 'Comfy hatchbacks • 4 seats',
            price: '\$95 est.',
            badge: 'Recommended',
          ),
          _VehicleOption(
            icon: Icons.local_taxi_rounded,
            title: 'Intercity Prime',
            subtitle: 'Premium sedans • 4 seats',
            price: '\$130 est.',
          ),
          _VehicleOption(
            icon: Icons.airport_shuttle_rounded,
            title: 'Intercity SUV',
            subtitle: 'Spacious SUVs • 6 seats',
            price: '\$180 est.',
          ),
          SizedBox(height: 14),
          _PrimaryBlackButton(label: 'Request Prime'),
        ],
      ),
    );
  }
}

class RentalsScreen extends StatelessWidget {
  const RentalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _UrbanScreen(
      title: 'Spott Rentals',
      subtitle: 'Hourly packages for flexible travel',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SearchPill(label: 'Pickup location'),
          SizedBox(height: 20),
          _SectionLabel('Select Package'),
          SizedBox(height: 12),
          _PackageCard(label: '1 hr / 10 km', price: '\$25'),
          _PackageCard(label: '2 hr / 20 km', price: '\$45', selected: true),
          _PackageCard(label: '4 hr / 40 km', price: '\$80'),
          SizedBox(height: 20),
          _SectionLabel('Included Vehicle'),
          SizedBox(height: 12),
          _VehicleOption(
            icon: Icons.directions_car_rounded,
            title: 'Premium Sedan',
            subtitle: 'Up to 4 passengers',
            price: 'Included',
          ),
          SizedBox(height: 14),
          _PrimaryBlackButton(label: 'Select Package'),
        ],
      ),
    );
  }
}

class UrbanSettingsScreen extends StatelessWidget {
  const UrbanSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;

    return _UrbanScreen(
      title: 'Settings',
      subtitle: 'Account, app, privacy, and preferences',
      child: Column(
        children: [
          const _SettingsRow(
            icon: Icons.person_rounded,
            title: 'Personal information',
            detail: 'Name, phone, email',
          ),
          const _SettingsRow(
            icon: Icons.credit_card_rounded,
            title: 'Payment methods',
            detail: 'Cards, wallet, vouchers',
          ),
          const _SettingsRow(
            icon: Icons.bookmark_rounded,
            title: 'Saved places',
            detail: 'Home, work, favorites',
          ),
          const _SettingsRow(
            icon: Icons.notifications_rounded,
            title: 'Notifications',
            detail: 'Trips, offers, safety',
          ),
          const _SettingsRow(
            icon: Icons.privacy_tip_rounded,
            title: 'Privacy',
            detail: 'Location and account controls',
          ),
          _WhiteCard(
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
    );
  }
}

class _UrbanScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _UrbanScreen({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.near_me_rounded,
                          size: 20,
                          color: isDark ? Colors.white : Colors.black,
                        ),
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
                  title,
                  style: TextStyle(
                    fontSize: 32,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFAFAFAF)
                        : const Color(0xFF5E5E5E),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchPill extends StatelessWidget {
  final String label;

  const _SearchPill({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 22,
            color: isDark ? Colors.white : Colors.black,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isDark
                    ? const Color(0xFFAFAFAF)
                    : const Color(0xFF5E5E5E),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleFilterRow extends StatelessWidget {
  final List<String> labels;

  const _VehicleFilterRow({required this.labels});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < labels.length; index++) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: index == 0
                    ? (isDark ? Colors.white : Colors.black)
                    : (isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFEFEFEF)),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                labels[index],
                style: TextStyle(
                  color: index == 0
                      ? (isDark ? Colors.black : Colors.white)
                      : (isDark ? Colors.white : Colors.black),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _ParkingMap extends StatelessWidget {
  const _ParkingMap();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 210,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE2E2E2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 34,
            left: 42,
            child: _MapPrice(label: '\$4/hr'),
          ),
          const Positioned(
            top: 90,
            right: 46,
            child: _MapPrice(label: '\$2/hr'),
          ),
          const Positioned(
            bottom: 38,
            left: 112,
            child: _MapPrice(label: '\$5/hr'),
          ),
          Center(
            child: Icon(
              Icons.my_location_rounded,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPrice extends StatelessWidget {
  final String label;

  const _MapPrice({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isDark ? Colors.black : Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _ParkingSpotCard extends StatelessWidget {
  final String title;
  final String detail;
  final String price;
  final String badge;
  final String imagePath;

  const _ParkingSpotCard({
    required this.title,
    required this.detail,
    required this.price,
    required this.badge,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Helper.line(context)),
        boxShadow: Helper.premiumShadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              decoration: BoxDecoration(
                color: Helper.canvasSoftColor(context),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.local_parking_rounded,
                      size: 48,
                      color: isDark ? Colors.white70 : Colors.black38,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      badge.toUpperCase(),
                      style: TextStyle(
                        color: Helper.mutedColor(context),
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Helper.inkColor(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Helper.inkColor(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: TextStyle(
                    color: Helper.mutedColor(context),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferHero extends StatelessWidget {
  const _OfferHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '50% OFF',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Airport Runs',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Valid until Nov 30',
            style: TextStyle(color: Color(0xFFD0D5DD)),
          ),
        ],
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String title;
  final String detail;
  final String action;

  const _OfferCard({
    required this.icon,
    required this.label,
    required this.title,
    required this.detail,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _WhiteCard(
      child: Row(
        children: [
          Icon(icon, size: 34, color: isDark ? Colors.white : Colors.black),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFAFAFAF)
                        : const Color(0xFF5E5E5E),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFAFAFAF)
                        : const Color(0xFF5E5E5E),
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Text(
            action,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationStack extends StatelessWidget {
  const _LocationStack();

  @override
  Widget build(BuildContext context) {
    return const _WhiteCard(
      child: Column(
        children: [
          _FormRow(icon: Icons.my_location_rounded, label: 'Pickup location'),
          Divider(height: 24),
          _FormRow(icon: Icons.location_on_rounded, label: 'Where to?'),
        ],
      ),
    );
  }
}

class _FormRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FormRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Icon(icon, size: 22, color: isDark ? Colors.white : Colors.black),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      label,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: isDark ? Colors.white : Colors.black,
      ),
    );
  }
}

class _DateChipRow extends StatelessWidget {
  const _DateChipRow();

  @override
  Widget build(BuildContext context) {
    const dates = ['Today 14', 'Tue 15', 'Wed 16', 'Thu 17', 'Fri 18'];
    return const _ChipWrap(labels: dates);
  }
}

class _TimeGrid extends StatelessWidget {
  const _TimeGrid();

  @override
  Widget build(BuildContext context) {
    const times = [
      '08:00 AM',
      '08:30 AM',
      '09:00 AM',
      '09:30 AM',
      '10:00 AM',
      '10:30 AM',
    ];
    return const _ChipWrap(labels: times);
  }
}

class _ChipWrap extends StatelessWidget {
  final List<String> labels;

  const _ChipWrap({required this.labels});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var index = 0; index < labels.length; index++)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: index == 0
                  ? (isDark ? Colors.white : Colors.black)
                  : (isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFEFEFEF)),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              labels[index],
              style: TextStyle(
                color: index == 0
                    ? (isDark ? Colors.black : Colors.white)
                    : (isDark ? Colors.white : Colors.black),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }
}

class _SegmentedControl extends StatelessWidget {
  final List<String> labels;

  const _SegmentedControl({required this.labels});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          for (var index = 0; index < labels.length; index++)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: index == 0
                      ? (isDark ? Colors.white : Colors.black)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  labels[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: index == 0
                        ? (isDark ? Colors.black : Colors.white)
                        : (isDark ? const Color(0xFFAFAFAF) : Colors.black),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow();

  @override
  Widget build(BuildContext context) {
    return const _WhiteCard(
      child: Row(
        children: [
          Expanded(
            child: _FormRow(
              icon: Icons.calendar_month_rounded,
              label: 'Today, 24 Oct',
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _FormRow(icon: Icons.schedule_rounded, label: 'Now'),
          ),
        ],
      ),
    );
  }
}

class _VehicleOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String price;
  final String? badge;

  const _VehicleOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.price,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _WhiteCard(
      child: Row(
        children: [
          Icon(icon, size: 34, color: isDark ? Colors.white : Colors.black),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (badge != null) ...[
                  Text(
                    badge!,
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFFAFAFAF)
                          : const Color(0xFF5E5E5E),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFAFAFAF)
                        : const Color(0xFF5E5E5E),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final String label;
  final String price;
  final bool selected;

  const _PackageCard({
    required this.label,
    required this.price,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _WhiteCard(
      color: selected
          ? (isDark ? Colors.white : Colors.black)
          : (isDark ? const Color(0xFF1E1E24) : Colors.white),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: selected
                    ? (isDark ? Colors.black : Colors.white)
                    : (isDark ? Colors.white : Colors.black),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            price,
            style: TextStyle(
              color: selected
                  ? (isDark ? Colors.black : Colors.white)
                  : (isDark ? Colors.white : Colors.black),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
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
    return _WhiteCard(
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
                    color: isDark
                        ? const Color(0xFFAFAFAF)
                        : const Color(0xFF5E5E5E),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
        ],
      ),
    );
  }
}

class _PrimaryBlackButton extends StatelessWidget {
  final String label;

  const _PrimaryBlackButton({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return FilledButton(
      onPressed: () => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$label started'))),
      style: FilledButton.styleFrom(
        backgroundColor: isDark ? Colors.white : Colors.black,
        foregroundColor: isDark ? Colors.black : Colors.white,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}

class _WhiteCard extends StatelessWidget {
  final Widget child;
  final Color color;

  const _WhiteCard({required this.child, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Resolve background and border colors
    Color resolvedBg;
    Color resolvedBorder;

    if (color == Colors.black) {
      resolvedBg = Colors.black;
      resolvedBorder = Colors.black;
    } else if (color == Colors.white) {
      resolvedBg = isDark ? const Color(0xFF1E1E24) : Colors.white;
      resolvedBorder = isDark
          ? Colors.white.withValues(alpha: 0.08)
          : const Color(0xFFE2E2E2);
    } else {
      resolvedBg = color;
      resolvedBorder = isDark
          ? Colors.white.withValues(alpha: 0.08)
          : const Color(0xFFE2E2E2);
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: resolvedBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: resolvedBorder),
      ),
      child: child,
    );
  }
}
