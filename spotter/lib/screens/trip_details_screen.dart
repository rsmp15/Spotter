import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/app_routes.dart';
import '../core/theme/redbus_theme.dart';
import '../core/components/redbus_sections.dart';

class TripDetailsScreen extends StatefulWidget {
  const TripDetailsScreen({super.key});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Set<int> _selectedSeats = {};

  // redBus-style seat layout: null = aisle, true = available, false = taken
  // Layout: 2 + aisle + 2
  static const List<List<bool?>> _seatLayout = [
    [true, true, null, true, false],   // row 1
    [false, true, null, true, true],   // row 2
    [true, false, null, false, true],  // row 3
    [true, true, null, true, true],    // row 4
    [false, false, null, true, true],  // row 5
    [true, true, null, false, true],   // row 6
  ];

  static const int _pricePerSeat = 850;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int _seatIndex(int row, int col) => row * 5 + col;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RBColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSeatsTab(),
                _buildDetailsTab(),
                _buildAmenitiesTab(),
              ],
            ),
          ),
          _buildBookingBar(context),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // HEADER
  // ══════════════════════════════════════════════════════════════════
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: RBColors.primary,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 4, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 22),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                  ),
                  const Expanded(
                    child: Text(
                      'Trip Details',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_rounded,
                        color: Colors.white, size: 20),
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.shareTrip),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            // Journey summary
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '07:30 AM',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Swargate, Pune',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const Text(
                        '6h 15m',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(width: 30, height: 1, color: Colors.white30),
                          const Icon(Icons.directions_car_rounded,
                              color: Colors.white54, size: 14),
                          Container(width: 30, height: 1, color: Colors.white30),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          '01:45 PM',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Central Stand, Kolhapur',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // TAB BAR
  // ══════════════════════════════════════════════════════════════════
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: RBColors.primary,
        unselectedLabelColor: RBColors.textMedium,
        indicatorColor: RBColors.primary,
        indicatorWeight: 2.5,
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Select Seats'),
          Tab(text: 'Trip Details'),
          Tab(text: 'Amenities'),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // TAB 1: SEAT SELECTION (redBus exact)
  // ══════════════════════════════════════════════════════════════════
  Widget _buildSeatsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Driver info card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(RBRadius.lg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: const NetworkImage(
                      'https://i.pravatar.cc/150?img=11'),
                  onBackgroundImageError: (exception, stackTrace) {},
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Arjun K.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: RBColors.textDark,
                        ),
                      ),
                      const Text(
                        'Honda City • MH 12 AB 1234',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: RBColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: RBColors.gold, size: 14),
                    const SizedBox(width: 2),
                    const Text(
                      '4.9',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: RBColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '(542 trips)',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: RBColors.textLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Seat legend
          Row(
            children: [
              _LegendDot(color: RBColors.seatAvailable, label: 'Available'),
              const SizedBox(width: 16),
              _LegendDot(color: RBColors.seatUnavailable, label: 'Booked'),
              const SizedBox(width: 16),
              _LegendDot(color: RBColors.seatSelected, label: 'Selected'),
            ],
          ),

          const SizedBox(height: 14),

          // Seat layout card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(RBRadius.lg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Column headers
                _buildSeatColumnHeaders(),
                const SizedBox(height: 8),
                // Seat rows
                ...List.generate(
                  _seatLayout.length,
                  (row) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildSeatRow(row),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Selected seats summary
          if (_selectedSeats.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: RBColors.seatSelected.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(RBRadius.md),
                border: Border.all(
                    color: RBColors.seatSelected.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_seat_rounded,
                      color: RBColors.seatSelected, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedSeats.length} seat${_selectedSeats.length > 1 ? 's' : ''} selected',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: RBColors.seatSelected,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '₹${_selectedSeats.length * _pricePerSeat}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: RBColors.primary,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSeatColumnHeaders() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _seatHeader('A'),
        const SizedBox(width: 8),
        _seatHeader('B'),
        const SizedBox(width: 24), // aisle
        _seatHeader('C'),
        const SizedBox(width: 8),
        _seatHeader('D'),
      ],
    );
  }

  Widget _seatHeader(String label) {
    return SizedBox(
      width: 40,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: RBColors.textMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildSeatRow(int row) {
    final cells = _seatLayout[row];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSeatCell(row, 0, cells[0]),
        const SizedBox(width: 8),
        _buildSeatCell(row, 1, cells[1]),
        // Aisle
        SizedBox(
          width: 24,
          child: Center(
            child: Text(
              '${row + 1}',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                color: RBColors.textLight,
              ),
            ),
          ),
        ),
        _buildSeatCell(row, 3, cells[3]),
        const SizedBox(width: 8),
        _buildSeatCell(row, 4, cells[4]),
      ],
    );
  }

  Widget _buildSeatCell(int row, int col, bool? available) {
    if (available == null) return const SizedBox(width: 40);

    final idx = _seatIndex(row, col);
    final isSelected = _selectedSeats.contains(idx);
    final isTaken = available == false;

    Color bg;
    Color border;
    Color iconColor;

    if (isTaken) {
      bg = RBColors.seatUnavailable.withValues(alpha: 0.12);
      border = RBColors.seatUnavailable.withValues(alpha: 0.3);
      iconColor = RBColors.seatUnavailable;
    } else if (isSelected) {
      bg = RBColors.seatSelected.withValues(alpha: 0.15);
      border = RBColors.seatSelected;
      iconColor = RBColors.seatSelected;
    } else {
      bg = RBColors.seatAvailable.withValues(alpha: 0.1);
      border = RBColors.seatAvailable.withValues(alpha: 0.5);
      iconColor = RBColors.seatAvailable;
    }

    return GestureDetector(
      onTap: isTaken
          ? null
          : () {
              HapticFeedback.selectionClick();
              setState(() {
                if (isSelected) {
                  _selectedSeats.remove(idx);
                } else if (_selectedSeats.length < 4) {
                  _selectedSeats.add(idx);
                }
              });
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: border, width: 1.5),
        ),
        child: Icon(
          Icons.event_seat_rounded,
          color: iconColor,
          size: 20,
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // TAB 2: TRIP DETAILS
  // ══════════════════════════════════════════════════════════════════
  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Journey Route
          _SectionCard(
            title: 'Journey Route',
            child: Column(
              children: [
                _RouteStop(
                  time: '07:30 AM',
                  date: 'Today',
                  city: 'Pune',
                  location: 'Swargate Bus Stand',
                  isFirst: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 11),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: RBColors.surfaceGrey,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: RBColors.divider),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_cafe_rounded,
                            color: RBColors.textMedium, size: 16),
                        const SizedBox(width: 8),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '15 min rest stop',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: RBColors.textDark,
                              ),
                            ),
                            Text(
                              'Lonavala',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                color: RBColors.textMedium,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                _RouteStop(
                  time: '01:45 PM',
                  date: 'Today',
                  city: 'Kolhapur',
                  location: 'Central Bus Stand',
                  isFirst: false,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Policies
          _SectionCard(
            title: 'Policies',
            child: Column(
              children: [
                _PolicyRow(
                  icon: Icons.cancel_outlined,
                  title: 'Cancellation',
                  value: 'Free within 24h of booking',
                  valueColor: RBColors.green,
                ),
                const Divider(height: 1, color: RBColors.divider),
                _PolicyRow(
                  icon: Icons.luggage_rounded,
                  title: 'Luggage',
                  value: '1 bag (15 kg max)',
                  valueColor: RBColors.textMedium,
                ),
                const Divider(height: 1, color: RBColors.divider),
                _PolicyRow(
                  icon: Icons.no_food_rounded,
                  title: 'Food',
                  value: 'No strong-smelling food',
                  valueColor: RBColors.textMedium,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Stats row
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(RBRadius.lg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatBox(value: '4.9', label: 'Rating'),
                  VerticalDivider(
                      color: RBColors.divider, width: 1),
                  _StatBox(value: '98%', label: 'Response'),
                  VerticalDivider(
                      color: RBColors.divider, width: 1),
                  _StatBox(value: '542', label: 'Trips'),
                  VerticalDivider(
                      color: RBColors.divider, width: 1),
                  _StatBox(value: '0.4%', label: 'Cancel rate'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // TAB 3: AMENITIES
  // ══════════════════════════════════════════════════════════════════
  Widget _buildAmenitiesTab() {
    final amenities = [
      (Icons.ac_unit_rounded, 'Climate Control', RBColors.blue),
      (Icons.wifi_rounded, 'Free Wi-Fi', RBColors.blue),
      (Icons.power_rounded, 'USB Charging', RBColors.green),
      (Icons.verified_user_rounded, 'ID Verified', RBColors.green),
      (Icons.directions_car_rounded, 'Vehicle Inspected', RBColors.green),
      (Icons.music_note_rounded, 'Music Available', RBColors.purple),
      (Icons.no_food_rounded, 'Non-Smoking', RBColors.orange),
      (Icons.pets_rounded, 'Pet Friendly', RBColors.orange),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(RBRadius.lg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                ),
              ],
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: amenities.length,
              itemBuilder: (_, i) {
                final a = amenities[i];
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: a.$3.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: a.$3.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(a.$1, color: a.$3, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          a.$2,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: RBColors.textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // BOOKING BAR (bottom sticky)
  // ══════════════════════════════════════════════════════════════════
  Widget _buildBookingBar(BuildContext context) {
    final count = _selectedSeats.length;
    final total = count * _pricePerSeat;
    final isVisible = count > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: isVisible ? (70.0 + MediaQuery.of(context).padding.bottom) : 0,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          height: 70.0 + MediaQuery.of(context).padding.bottom,
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(context).padding.bottom + 12,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$count seat${count > 1 ? 's' : ''} selected',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: RBColors.textMedium,
                      ),
                    ),
                    Text(
                      '₹$total',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: RBColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pushNamed(context, AppRoutes.confirmRide);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RBColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(RBRadius.md),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'PROCEED',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// HELPER WIDGETS
// ════════════════════════════════════════════════════════════════════
class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: color, width: 1.5),
          ),
          child: Icon(Icons.event_seat_rounded, size: 9, color: color),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: RBColors.textMedium,
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return RBSectionContainer(
      style: RBSectionStyle.floating,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: RBColors.textDark,
              ),
            ),
          ),
          const Divider(height: 1, color: RBColors.divider),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _RouteStop extends StatelessWidget {
  final String time;
  final String date;
  final String city;
  final String location;
  final bool isFirst;
  const _RouteStop({
    required this.time,
    required this.date,
    required this.city,
    required this.location,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: isFirst ? RBColors.primary : RBColors.blue,
                  width: 5,
                ),
              ),
            ),
            if (!isFirst) const SizedBox.shrink(),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                city,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: RBColors.textDark,
                ),
              ),
              Text(
                location,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: RBColors.textMedium,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              time,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: RBColors.textDark,
              ),
            ),
            Text(
              date,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: RBColors.textLight,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PolicyRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color valueColor;
  const _PolicyRow(
      {required this.icon,
      required this.title,
      required this.value,
      required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: RBColors.textMedium),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: RBColors.textDark,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  const _StatBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: RBColors.textDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            color: RBColors.textLight,
          ),
        ),
      ],
    );
  }
}
