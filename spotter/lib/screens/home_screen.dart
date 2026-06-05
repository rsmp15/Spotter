import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../models/spott_models.dart';
import '../core/theme/redbus_theme.dart';
import '../core/components/redbus_sections.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _from = 'Pune';
  String _to = 'Mumbai';
  DateTime _selectedDate = DateTime.now();
  int _passengers = 1;

  void _swapCities() {
    HapticFeedback.lightImpact();
    setState(() {
      final temp = _from;
      _from = _to;
      _to = temp;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: RBColors.primary,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  String get _formattedDate {
    final now = DateTime.now();
    final diff = _selectedDate
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[_selectedDate.weekday - 1]}, '
        '${_selectedDate.day} ${months[_selectedDate.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);

    // Redirect Travelers to driverHome
    if (ride.currentUserRole == UserRole.traveler) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.driverHome);
      });
      return const Scaffold(
        backgroundColor: RBColors.background,
        body: Center(
          child: CircularProgressIndicator(color: RBColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: RBColors.background,
      body: Column(
        children: [
          _buildRedHeader(context),
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. Search Section (Hero style brand gradient)
                SliverToBoxAdapter(
                  child: _buildSearchSection(context),
                ),
                
                // Transition Wave
                const SliverToBoxAdapter(
                  child: RBWaveSeparator(
                    topColor: RBColors.primary,
                    bottomColor: Colors.white,
                  ),
                ),

                // 2. Suggestions / Services Section (White Background)
                SliverToBoxAdapter(
                  child: RBSectionContainer(
                    style: RBSectionStyle.white,
                    child: _buildSuggestionsGrid(context),
                  ),
                ),

                // Spacing 48px
                const SliverToBoxAdapter(
                  child: SizedBox(height: 48),
                ),

                // 3. Offers & Deals Section (Rewards light red background)
                SliverToBoxAdapter(
                  child: RBSectionContainer(
                    style: RBSectionStyle.rewards,
                    topRadius: 32,
                    bottomRadius: 32,
                    child: _buildOffersSection(),
                  ),
                ),

                // Spacing 48px
                const SliverToBoxAdapter(
                  child: SizedBox(height: 48),
                ),

                // 4. Popular Routes Section (White Background)
                SliverToBoxAdapter(
                  child: RBSectionContainer(
                    style: RBSectionStyle.white,
                    child: _buildPopularRoutesSection(context),
                  ),
                ),

                // Spacing 48px
                const SliverToBoxAdapter(
                  child: SizedBox(height: 48),
                ),

                // 5. Marketplace / Parcel Banner (neutral background, curved container)
                SliverToBoxAdapter(
                  child: RBSectionContainer(
                    style: RBSectionStyle.marketplace,
                    topRadius: 24,
                    bottomRadius: 24,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    child: _buildParcelBanner(context),
                  ),
                ),

                // Spacing 48px
                const SliverToBoxAdapter(
                  child: SizedBox(height: 48),
                ),

                // 6. Community / Become a Traveler Banner (curved container)
                SliverToBoxAdapter(
                  child: RBSectionContainer(
                    style: RBSectionStyle.community,
                    topRadius: 24,
                    bottomRadius: 24,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    child: _buildTravelerBanner(context),
                  ),
                ),

                // Spacing 48px
                const SliverToBoxAdapter(
                  child: SizedBox(height: 48),
                ),

                // 7. Why choose Spotter (floating container)
                SliverToBoxAdapter(
                  child: _buildWhySpotterSection(),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 120),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // RED HEADER — redBus style
  // ══════════════════════════════════════════════════════════════════
  Widget _buildRedHeader(BuildContext context) {
    return Container(
      color: RBColors.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              // Logo mark
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  color: RBColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'spotter',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Colors.white, size: 22),
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.notifications),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                child: const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // BRAND HERO SEARCH SECTION
  // ══════════════════════════════════════════════════════════════════
  Widget _buildSearchSection(BuildContext context) {
    return RBSectionContainer(
      style: RBSectionStyle.brandHero,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.tripSearch),
            child: const Text(
              'Where to?',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -0.8,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSearchCard(context),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // SEARCH CARD — redBus exact FROM/TO style
  // ══════════════════════════════════════════════════════════════════
  Widget _buildSearchCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(RBRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Mode tabs
          Container(
            decoration: const BoxDecoration(
              color: RBColors.primarySoft,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(RBRadius.xl),
                topRight: Radius.circular(RBRadius.xl),
              ),
            ),
            child: Row(
              children: [
                _ModeTab(
                  label: 'Find Ride',
                  icon: Icons.directions_car_rounded,
                  isActive: true,
                  isFirst: true,
                  onTap: () {},
                ),
                _ModeTab(
                  label: 'Send Parcel',
                  icon: Icons.inventory_2_rounded,
                  isActive: false,
                  isFirst: false,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.parcelBooking),
                ),
                _ModeTab(
                  label: 'Offer Trip',
                  icon: Icons.add_road_rounded,
                  isActive: false,
                  isFirst: false,
                  isLast: true,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.createTrip),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // FROM / TO box
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: RBColors.divider),
                    borderRadius: BorderRadius.circular(RBRadius.lg),
                  ),
                  child: Column(
                    children: [
                      _CityRow(
                        icon: Icons.radio_button_checked_rounded,
                        iconColor: RBColors.green,
                        label: 'From',
                        city: _from,
                        onTap: () => _showCityPicker(context, isFrom: true),
                      ),
                      // Divider + swap button
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          const Divider(height: 1, color: RBColors.divider),
                          Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: GestureDetector(
                                onTap: _swapCities,
                                child: Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: RBColors.primary, width: 1.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: RBColors.primary
                                            .withValues(alpha: 0.15),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.swap_vert_rounded,
                                    color: RBColors.primary,
                                    size: 18,
                                  ),
                                ),
                              ),
                          ),
                        ],
                      ),
                      _CityRow(
                        icon: Icons.location_on_rounded,
                        iconColor: RBColors.primary,
                        label: 'To',
                        city: _to,
                        onTap: () => _showCityPicker(context, isFrom: false),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Date + Passengers
                Row(
                  children: [
                    Expanded(
                      child: _InputBox(
                        icon: Icons.calendar_today_rounded,
                        label: 'Date',
                        value: _formattedDate,
                        onTap: _pickDate,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _InputBox(
                        icon: Icons.person_outline_rounded,
                        label: 'Passengers',
                        value: '$_passengers Seat${_passengers > 1 ? 's' : ''}',
                        onTap: () {
                          setState(() {
                            _passengers = _passengers >= 4 ? 1 : _passengers + 1;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Search button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pushNamed(context, AppRoutes.tripSearch);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RBColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(RBRadius.lg),
                      ),
                    ),
                    child: const Text(
                      'SEARCH RIDES',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // OFFERS SECTION
  // ══════════════════════════════════════════════════════════════════
  Widget _buildOffersSection() {
    return RBCarouselSection(
      title: 'Offers & Deals',
      subtitle: 'Get best deals and discounts',
      items: [
        _OfferCard(
          color: const Color(0xFFE53935),
          title: 'Flat 20% OFF',
          subtitle: 'Use code: SPOTT20',
          icon: Icons.local_offer_rounded,
        ),
        _OfferCard(
          color: const Color(0xFF1976D2),
          title: 'First Ride Free',
          subtitle: 'New users only',
          icon: Icons.card_giftcard_rounded,
        ),
        _OfferCard(
          color: const Color(0xFF388E3C),
          title: 'Refer & Earn',
          subtitle: '₹100 per referral',
          icon: Icons.share_rounded,
        ),
      ],
      itemHeight: 110,
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // POPULAR ROUTES
  // ══════════════════════════════════════════════════════════════════
  Widget _buildPopularRoutesSection(BuildContext context) {
    const routes = [
      ('Pune', 'Mumbai', '₹450', '3h'),
      ('Mumbai', 'Pune', '₹450', '3h'),
      ('Pune', 'Nashik', '₹380', '4h'),
      ('Pune', 'Goa', '₹1200', '9h'),
      ('Mumbai', 'Surat', '₹600', '5h'),
    ];

    return RBCarouselSection(
      title: 'Popular Routes',
      subtitle: 'Top traveled routes near you',
      itemHeight: 76,
      items: routes.map((r) {
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.tripSearch),
          child: Container(
            width: 160,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(RBRadius.lg),
              border: Border.all(color: RBColors.divider),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(r.$1,
                        style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: RBColors.textDark)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(Icons.arrow_forward_rounded,
                          size: 11, color: RBColors.textLight),
                    ),
                    Text(r.$2,
                        style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: RBColors.textDark)),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(r.$3,
                        style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: RBColors.primary)),
                    const Text(' · ',
                        style: TextStyle(
                            fontSize: 11,
                            color: RBColors.textLight)),
                    Text(r.$4,
                        style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: RBColors.textLight)),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // SUGGESTIONS GRID (named Suggestions for tests compatibility)
  // ══════════════════════════════════════════════════════════════════
  Widget _buildSuggestionsGrid(BuildContext context) {
    final services = [
      (Icons.directions_car_rounded, 'Ride Share',
          RBColors.primary, AppRoutes.tripSearch),
      (Icons.inventory_2_rounded, 'Send Parcel',
          const Color(0xFF7B1FA2), AppRoutes.parcelBooking),
      (Icons.add_road_rounded, 'Offer Trip',
          const Color(0xFF1565C0), AppRoutes.createTrip),
      (Icons.route_rounded, 'Activity',
          const Color(0xFF2E7D32), AppRoutes.activity),
      (Icons.safety_check_rounded, 'Safety',
          const Color(0xFFF57C00), AppRoutes.safetyToolkit),
      (Icons.support_agent_rounded, 'Support',
          const Color(0xFF00838F), AppRoutes.support),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RBSectionHeader(
          title: 'Suggestions',
          subtitle: 'Quick actions and co-travel services',
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.05,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: services.length,
          itemBuilder: (context, i) {
            final s = services[i];
            return GestureDetector(
              onTap: () => Navigator.pushNamed(context, s.$4),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(RBRadius.lg),
                  border: Border.all(color: RBColors.divider),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: s.$3.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(s.$1, color: s.$3, size: 21),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      s.$2,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: RBColors.textDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // PARCEL BANNER
  // ══════════════════════════════════════════════════════════════════
  Widget _buildParcelBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.parcelBooking),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              Icons.inventory_2_rounded,
              size: 90,
              color: const Color(0xFF6A1B9A).withValues(alpha: 0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF6A1B9A).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'PARCEL DELIVERY',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6A1B9A),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Send Parcels from ₹99',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: RBColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Fast peer-to-peer dispatch via verified travelers.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: RBColors.textMedium,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.parcelBooking),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A1B9A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Send Parcel Now',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // BECOME A TRAVELER BANNER
  // ══════════════════════════════════════════════════════════════════
  Widget _buildTravelerBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.createTrip),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Become a Traveler',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0D47A1),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Earn ₹800 avg per trip. Offer empty seats.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: RBColors.textMedium,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.createTrip),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Start Earning',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.directions_car_rounded,
            size: 70,
            color: Colors.blueGrey,
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // WHY SPOTTER SECTION
  // ══════════════════════════════════════════════════════════════════
  Widget _buildWhySpotterSection() {
    return RBSectionContainer(
      style: RBSectionStyle.floating,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Why choose Spotter?',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: RBColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          const _WhyRow(
              icon: Icons.verified_user_rounded,
              title: 'Verified Travelers',
              subtitle: 'Every driver is ID & vehicle verified'),
          const _WhyRow(
              icon: Icons.savings_rounded,
              title: 'Save upto 60%',
              subtitle: 'Vs solo cab or bus'),
          const _WhyRow(
              icon: Icons.bolt_rounded,
              title: 'Instant Booking',
              subtitle: 'Confirm in seconds'),
          const _WhyRow(
              icon: Icons.headset_mic_rounded,
              title: '24/7 Support',
              subtitle: 'Help when you need it'),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // CITY PICKER BOTTOM SHEET
  // ══════════════════════════════════════════════════════════════════
  void _showCityPicker(BuildContext context, {required bool isFrom}) {
    const cities = [
      'Pune', 'Mumbai', 'Nashik', 'Aurangabad', 'Kolhapur',
      'Nagpur', 'Solapur', 'Goa', 'Bangalore', 'Hyderabad',
      'Delhi', 'Ahmedabad', 'Surat', 'Chennai', 'Jaipur',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: RBColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                isFrom ? 'Select Origin City' : 'Select Destination City',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: RBColors.textDark,
                ),
              ),
            ),
            const Divider(height: 1, color: RBColors.divider),
            Expanded(
              child: ListView.separated(
                itemCount: cities.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  indent: 14,
                  color: RBColors.divider,
                ),
                itemBuilder: (_, i) => ListTile(
                  leading: const Icon(Icons.location_city_rounded,
                      color: RBColors.textLight, size: 20),
                  title: Text(
                    cities[i],
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: RBColors.textDark,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      if (isFrom) {
                        _from = cities[i];
                      } else {
                        _to = cities[i];
                      }
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// PRIVATE HELPER WIDGETS
// ════════════════════════════════════════════════════════════════════

class _ModeTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const _ModeTab({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.isFirst,
    this.isLast = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? RBColors.primary : Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: isFirst
                  ? const Radius.circular(RBRadius.xl)
                  : Radius.zero,
              topRight: isLast
                  ? const Radius.circular(RBRadius.xl)
                  : Radius.zero,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 14,
                  color: isActive ? Colors.white : RBColors.textMedium),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isActive ? Colors.white : RBColors.textMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CityRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String city;
  final VoidCallback onTap;

  const _CityRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.city,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 19),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: RBColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    city,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: RBColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded,
                color: RBColors.textLight, size: 18),
          ],
        ),
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _InputBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RBRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          border: Border.all(color: RBColors.divider),
          borderRadius: BorderRadius.circular(RBRadius.lg),
        ),
        child: Row(
          children: [
            Icon(icon, color: RBColors.primary, size: 16),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          color: RBColors.textLight)),
                  Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: RBColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

class _OfferCard extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final IconData icon;

  const _OfferCard({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(RBRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WhyRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _WhyRow(
      {required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: RBColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: RBColors.primary, size: 17),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: RBColors.textDark)),
                Text(subtitle,
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: RBColors.textLight)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
