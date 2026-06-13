import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/app_assets.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../models/spott_models.dart';





import '../widgets/premium/premium_selectors.dart';

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
    final picked = await PremiumDatePickerBottomSheet.show(
      context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      primaryColor: DSColors.primary,
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
    // HomeScreen is now universal for both User and Rider, no traveler redirect.

    return Scaffold(
      backgroundColor: DSColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. Search Section (Hero style brand gradient)
                SliverToBoxAdapter(
                  child: _buildSearchSection(context),
                ),

                // 2. Suggestions / Services Section
                SliverToBoxAdapter(
                  child: _SectionContainer(
                    child: _buildSuggestionsGrid(context),
                  ),
                ),

                // 3. Offers & Deals Section
                SliverToBoxAdapter(
                  child: _SectionContainer(
                    backgroundColor: DSColors.primarySoft,
                    child: _buildOffersSection(),
                  ),
                ),

                // 4. Popular Routes Section
                SliverToBoxAdapter(
                  child: _SectionContainer(
                    child: _buildPopularRoutesSection(context),
                  ),
                ),

                // 5. Marketplace / Parcel Banner
                SliverToBoxAdapter(
                  child: _SectionContainer(
                    backgroundColor: DSColors.surfaceVariant,
                    child: _buildParcelBanner(context),
                  ),
                ),

                // 6. Community / Become a Traveler Banner
                if (RideScope.of(context).currentUserRole != UserRole.rider)
                  SliverToBoxAdapter(
                    child: _SectionContainer(
                      backgroundColor: DSColors.primarySoft,
                      child: _buildTravelerBanner(context),
                    ),
                  ),

                // 7. Why choose Spotter
                SliverToBoxAdapter(
                  child: _buildWhySpotterSection(),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 120.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // HEADER
  // ══════════════════════════════════════════════════════════════════
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: DSColors.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              // Logo mark
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  color: DSColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'spotter',
                style: DSTypography.headline.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Colors.white, size: 24),
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.notifications),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person_rounded,
                      color: Colors.white, size: 20),
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
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [DSColors.primary, DSColors.primaryDark],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(DSRadius.xxl)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.tripSearch),
            child: Text(
              'Where to?',
              style: DSTypography.displayLarge.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -0.8,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildTrustBar(),
          const SizedBox(height: 16),
          _buildSearchCard(context),
        ],
      ),
    );
  }

  Widget _buildTrustBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTrustBarPill(Icons.verified_user_outlined, 'Verified Drivers'),
        _buildTrustBarPill(Icons.currency_rupee_outlined, '₹0 Platform Fee'),
        _buildTrustBarPill(Icons.support_agent_outlined, '24/7 Support'),
      ],
    );
  }

  Widget _buildTrustBarPill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // SEARCH CARD
  // ══════════════════════════════════════════════════════════════════
  Widget _buildSearchCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DSRadius.card),
        boxShadow: DSShadows.elevation3,
        border: Border.all(color: DSColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // FROM / TO box
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: DSColors.border),
                    borderRadius: BorderRadius.circular(DSRadius.lg),
                    color: DSColors.surfaceVariant,
                  ),
                  child: Column(
                    children: [
                      _CityRow(
                        icon: Icons.radio_button_checked_rounded,
                        iconColor: DSColors.success,
                        label: 'From',
                        city: _from,
                        onTap: () => _showCityPicker(context, isFrom: true),
                      ),
                      // Divider + swap button
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          const Divider(height: 1, color: DSColors.divider),
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: GestureDetector(
                              onTap: _swapCities,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: DSColors.primary, width: 1.5),
                                  boxShadow: DSShadows.elevation1,
                                ),
                                child: const Icon(
                                  Icons.swap_vert_rounded,
                                  color: DSColors.primary,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      _CityRow(
                        icon: Icons.location_on_rounded,
                        iconColor: DSColors.primary,
                        label: 'To',
                        city: _to,
                        onTap: () => _showCityPicker(context, isFrom: false),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

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
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InputBox(
                        icon: Icons.person_outline_rounded,
                        label: 'Passengers',
                        value: '$_passengers Seat${_passengers > 1 ? 's' : ''}',
                        onTap: () async {
                          final picked = await PremiumPassengersBottomSheet.show(
                            context,
                            initialSeats: _passengers,
                            maxSeats: 4,
                            primaryColor: DSColors.primary,
                            title: 'Select Seats',
                            subtitle: 'Choose how many seats to book',
                          );
                          if (picked != null) {
                            setState(() => _passengers = picked);
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Search button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pushNamed(context, AppRoutes.tripSearch);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DSColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(DSRadius.button),
                      ),
                      textStyle: DSTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    child: const Text('SEARCH RIDES'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Offers & Deals',
          style: DSTypography.headline.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Get best deals and discounts',
          style: DSTypography.caption.copyWith(color: DSColors.textSecondary),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: const [
              _OfferCard(
                color: Color(0xFFE53935),
                title: 'Flat 20% OFF',
                subtitle: 'Use code: SPOTT20',
                icon: Icons.local_offer_rounded,
              ),
              SizedBox(width: 12),
              _OfferCard(
                color: Color(0xFF1976D2),
                title: 'First Ride Free',
                subtitle: 'New users only',
                icon: Icons.card_giftcard_rounded,
              ),
              SizedBox(width: 12),
              _OfferCard(
                color: Color(0xFF43A047),
                title: 'Refer & Earn',
                subtitle: '₹100 per referral',
                icon: Icons.share_rounded,
              ),
            ],
          ),
        ),
      ],
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Routes',
          style: DSTypography.headline.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Top traveled routes near you',
          style: DSTypography.caption.copyWith(color: DSColors.textSecondary),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: routes.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final r = routes[i];
              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.tripSearch),
                child: Container(
                  width: 160,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(DSRadius.lg),
                    border: Border.all(color: DSColors.border),
                    boxShadow: DSShadows.elevation1,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            r.$1,
                            style: DSTypography.labelLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: DSColors.textPrimary,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(Icons.arrow_forward_rounded,
                                size: 12, color: DSColors.textTertiary),
                          ),
                          Text(
                            r.$2,
                            style: DSTypography.labelLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: DSColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            r.$3,
                            style: DSTypography.caption.copyWith(
                              fontWeight: FontWeight.bold,
                              color: DSColors.primary,
                            ),
                          ),
                          Text(
                            ' · ${r.$4}',
                            style: DSTypography.caption.copyWith(
                              color: DSColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // SUGGESTIONS GRID
  // ══════════════════════════════════════════════════════════════════
  Widget _buildSuggestionsGrid(BuildContext context) {
    final services = [
      (Icons.directions_car_rounded, 'Ride Share',
          DSColors.primary, AppRoutes.tripSearch),
      (Icons.inventory_2_rounded, 'Send Parcel',
          Color(0xFF8E24AA), AppRoutes.parcelBooking),
      (Icons.add_road_rounded, 'Offer Trip',
          Color(0xFF1976D2), AppRoutes.createTrip),
      (Icons.route_rounded, 'Activity',
          Color(0xFF43A047), AppRoutes.activity),
      (Icons.safety_check_rounded, 'Safety',
          DSColors.warning, AppRoutes.safetyToolkit),
      (Icons.support_agent_rounded, 'Support',
          DSColors.info, AppRoutes.support),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggestions',
          style: DSTypography.headline.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Quick actions and co-travel services',
          style: DSTypography.caption.copyWith(color: DSColors.textSecondary),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.05,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: services.length,
          itemBuilder: (context, i) {
            final s = services[i];
            String? assetPath;
            if (s.$2 == 'Ride Share') {
              assetPath = AppAssets.bikeClock;
            } else if (s.$2 == 'Send Parcel') {
              assetPath = AppAssets.parcel;
            } else if (s.$2 == 'Offer Trip') {
              assetPath = AppAssets.bike;
            } else if (s.$2 == 'Activity') {
              assetPath = AppAssets.calendar;
            } else if (s.$2 == 'Support') {
              assetPath = AppAssets.support;
            }

            return _PressScale(
              onTap: () {
                if (s.$4 == AppRoutes.safetyToolkit) {
                  Navigator.pushNamed(context, AppRoutes.safetyToolkit);
                } else if (s.$4 == AppRoutes.activity) {
                  RideScope.of(context).switchTab(2);
                } else if (s.$4 == AppRoutes.createTrip) {
                  _handleOfferTrip(context);
                } else {
                  Navigator.pushNamed(context, s.$4);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(DSRadius.card),
                  border: Border.all(color: DSColors.border),
                  boxShadow: DSShadows.elevation1,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: assetPath != null ? Colors.transparent : s.$3.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: assetPath != null
                          ? Image.asset(
                              assetPath,
                              fit: BoxFit.contain,
                            )
                          : Icon(s.$1, color: s.$3, size: 26),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      s.$2,
                      style: DSTypography.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: DSColors.textPrimary,
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
              color: Color(0xFF8E24AA).withValues(alpha: 0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF8E24AA).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(DSRadius.xs),
                ),
                child: const Text(
                  'PARCEL DELIVERY',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8E24AA),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Send Parcels from ₹99',
                style: DSTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: DSColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Fast peer-to-peer dispatch via verified travelers.',
                style: DSTypography.body.copyWith(
                  color: DSColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.parcelBooking),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8E24AA),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DSRadius.sm),
                  ),
                  textStyle: DSTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                ),
                child: const Text('Send Parcel Now'),
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
      onTap: () => _handleOfferTrip(context),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Become a Rider',
                  style: DSTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1976D2),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Earn ₹800 avg per trip. Offer empty seats.',
                  style: DSTypography.body.copyWith(
                    color: DSColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _handleOfferTrip(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(DSRadius.sm),
                    ),
                    textStyle: DSTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Start Earning'),
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

  void _handleOfferTrip(BuildContext context) {
    final ride = RideScope.of(context);
    if (ride.currentUserRole == UserRole.rider) {
      Navigator.pushNamed(context, AppRoutes.createTrip);
    } else {
      _showKycPromptBottomSheet(context);
    }
  }

  void _showKycPromptBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              const Icon(
                Icons.verified_user_rounded,
                color: DSColors.primary,
                size: 56,
              ),
              const SizedBox(height: 16),
              Text(
                'Become a Rider',
                style: DSTypography.headline.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),
              Text(
                'To offer and share rides, you need to complete a quick identity verification (KYC).',
                textAlign: TextAlign.center,
                style: DSTypography.body.copyWith(color: DSColors.textSecondary),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: DSColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Maybe Later', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.kyc);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DSColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Start KYC', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // WHY SPOTTER SECTION
  // ══════════════════════════════════════════════════════════════════
  Widget _buildWhySpotterSection() {
    return _SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why choose Spotter?',
            style: DSTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const _WhyRow(
              icon: Icons.verified_user_rounded,
              title: 'Verified Travelers',
              subtitle: 'Every driver is ID & vehicle verified'),
          const SizedBox(height: 12),
          const _WhyRow(
              icon: Icons.savings_rounded,
              title: 'Save upto 60%',
              subtitle: 'Vs solo cab or bus'),
          const SizedBox(height: 12),
          const _WhyRow(
              icon: Icons.bolt_rounded,
              title: 'Instant Booking',
              subtitle: 'Confirm in seconds'),
          const SizedBox(height: 12),
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(DSRadius.bottomSheet)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: DSColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                isFrom ? 'Select Origin City' : 'Select Destination City',
                style: DSTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: DSColors.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1, color: DSColors.divider),
            Expanded(
              child: ListView.separated(
                itemCount: cities.length,
                separatorBuilder: (_, _) => const Divider(
                  height: 1,
                  indent: 14,
                  color: DSColors.divider,
                ),
                itemBuilder: (_, i) => ListTile(
                  leading: const Icon(Icons.location_city_rounded,
                      color: DSColors.textTertiary, size: 20),
                  title: Text(
                    cities[i],
                    style: DSTypography.body.copyWith(
                      fontWeight: FontWeight.w500,
                      color: DSColors.textPrimary,
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

class _SectionContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const _SectionContainer({
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? DSColors.surface,
        borderRadius: BorderRadius.circular(DSRadius.card),
        border: Border.all(color: DSColors.border),
        boxShadow: DSShadows.elevation1,
      ),
      child: child,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: DSTypography.caption.copyWith(
                      color: DSColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    city,
                    style: DSTypography.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: DSColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded,
                color: DSColors.textTertiary, size: 20),
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
      borderRadius: BorderRadius.circular(DSRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: DSColors.surfaceVariant,
          border: Border.all(color: DSColors.border),
          borderRadius: BorderRadius.circular(DSRadius.lg),
        ),
        child: Row(
          children: [
            Icon(icon, color: DSColors.primary, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: DSTypography.caption.copyWith(
                      color: DSColors.textTertiary,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: DSTypography.body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: DSColors.textPrimary,
                      fontSize: 13,
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
      width: 195,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DSRadius.lg),
        boxShadow: DSShadows.elevation1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
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
                  fontSize: 11,
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

  const _WhyRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: DSColors.primarySoft,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: DSColors.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: DSTypography.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: DSColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: DSTypography.caption.copyWith(
                  color: DSColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PressScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _PressScale({required this.child, required this.onTap});

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
