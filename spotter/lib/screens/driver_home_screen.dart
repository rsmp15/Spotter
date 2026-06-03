import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../custom_button.dart';
import '../helper.dart';
import '../spotter_widgets.dart';
import 'driver_bottom_nav.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  // Destination travel flow states
  bool _isTravelActive = false;
  String? _destination;
  bool _isRideStarted = false;

  // Stats to increment when a trip is completed
  int _completedTripsToday = 2;
  int _todayEarnings = 1240;

  static const List<String> _popularDestinations = [
    'Koregaon Park',
    'Baner',
    'Hinjawadi IT Park',
    'Viman Nagar',
    'Pune Airport',
  ];

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;

    // If ride is started, show high-fidelity navigation screen
    if (_isRideStarted) {
      return _buildNavigationScreen(context, isDark);
    }

    return SpotterScreen(
      title: 'Earn on your trip',
      subtitle: 'Accept seat requests on your route.',
      showBack: false,
      showMenu: true,
      bottomNavigationBar: const DriverBottomNav(activeTab: DriverBottomTab.home),
      content: [
        RecoveryBanner(state: ride.actionState, onRetry: ride.retryInitialize),
        
        // Active destination filter warning/status
        if (_isTravelActive && _destination != null)
          _buildDestinationFilterCard(context, isDark),

        // Earning Graph (Uber style)
        _buildUberEarningCard(context, isDark),

        // Rides & Parcels breakdown
        _buildRidesParcelsBreakdownCard(context, isDark),

        // Nearby requests card
        const SpotterCard(
          children: [
            Text(
              'Trip requests nearby',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            InfoRow(label: 'Best cost share', value: 'Rs 650'),
            InfoRow(label: 'Closest pickup', value: '1.2 km'),
            InfoRow(label: 'Seats requested', value: '2'),
          ],
        ),

        // Travel Destination Picker Action
        if (!_isTravelActive)
          _buildStartTravelCard(context, isDark)
        else
          _buildGoOnlineActionCard(context, isDark),

        const SizedBox(height: 12),
        const DriverRequestsAction(),
      ],
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildDestinationFilterCard(BuildContext context, bool isDark) {
    return SpotterCard(
      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF0F9FF),
      children: [
        Row(
          children: [
            Icon(
              Icons.directions_outlined,
              color: isDark ? Colors.blueAccent : const Color(0xFF0284C7),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Destination Filter Active',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: isDark ? Colors.white : const Color(0xFF0369A1),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Only accepting requests toward $_destination',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white70 : const Color(0xFF075985),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 20),
              onPressed: () {
                setState(() {
                  _isTravelActive = false;
                  _destination = null;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Destination filter cleared')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUberEarningCard(BuildContext context, bool isDark) {
    final textColor = Helper.inkColor(context);
    final cardBg = isDark ? const Color(0xFF161922) : Colors.white;

    // Weekly earnings heights for Mon-Sun (percentage values)
    final weeklyEarnings = [0.4, 0.6, 0.35, 0.8, 0.5, 0.9, 0.7];
    final weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return SpotterCard(
      color: cardBg,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trip earnings this week',
                    style: TextStyle(color: Helper.muted, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rs ${_todayEarnings + 7210}',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: textColor),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    'Today: Rs $_todayEarnings',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Bar Chart
        SizedBox(
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final isToday = index == 5; // Simulating Saturday as today
              final barColor = isToday
                  ? (isDark ? Colors.white : Colors.black)
                  : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0));

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 24,
                    height: 80 * weeklyEarnings[index],
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    weekDays[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isToday ? FontWeight.w900 : FontWeight.w500,
                      color: isToday ? textColor : Helper.muted,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        const SizedBox(height: 16),
        const Divider(height: 1, color: Helper.lineColor),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatCol('Completed', '$_completedTripsToday trips'),
            _buildStatCol('Online hours', '5h 12m'),
            _buildStatCol('Rating', '4.95 ★'),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Helper.muted, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildRidesParcelsBreakdownCard(BuildContext context, bool isDark) {
    final cardBg = isDark ? const Color(0xFF161922) : Colors.white;

    return SpotterCard(
      color: cardBg,
      children: [
        const Text(
          'Trips & Parcels split',
          style: TextStyle(color: Helper.muted, fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              flex: 65, // 65% Rides
              child: Container(
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(6)),
                ),
              ),
            ),
            const SizedBox(width: 2),
            Expanded(
              flex: 35, // 35% Parcels
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white70 : const Color(0xFF6366F1),
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(6)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                const Text('Trips (65%)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white70 : const Color(0xFF6366F1),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text('Parcels (35%)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStartTravelCard(BuildContext context, bool isDark) {
    return SpotterCard(
      color: isDark ? Colors.white : Colors.black,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Set destination travel',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.black : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Accept seat requests matching your way.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.black54 : Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _openLocationPicker(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.black : Colors.white,
                foregroundColor: isDark ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Start Travel'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGoOnlineActionCard(BuildContext context, bool isDark) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          child: CustomButton(
            label: 'ACCEPTING REQUESTS',
            onPressed: () {
              setState(() {
                _isRideStarted = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Trip started heading toward $_destination!')),
              );
            },
          ),
        ),
        Text(
          'Ready to travel to $_destination',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: Helper.muted, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // Active Navigation/Travel Screen
  Widget _buildNavigationScreen(BuildContext context, bool isDark) {
    final textColor = Helper.inkColor(context);
    final cardBg = isDark ? const Color(0xFF161922) : Colors.white;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.navigation_rounded, color: Colors.blueAccent, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Active Trip',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textColor),
                        ),
                        Text(
                          'Traveling toward $_destination',
                          style: const TextStyle(fontSize: 13, color: Helper.muted, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Map area
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: MapPlaceholder(height: 380),
              ),
            ),
            // Destination navigation card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SpotterCard(
                color: cardBg,
                children: [
                  const StatusChip(label: 'ROUTE ACTIVE', color: Helper.success),
                  const SizedBox(height: 12),
                  Text(
                    'Arriving in 18 mins',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: textColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Distance remaining: 6.4 km',
                    style: TextStyle(fontSize: 14, color: Helper.mutedColor(context), fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          label: 'COMPLETE TRIP',
                          onPressed: () {
                            setState(() {
                              _isRideStarted = false;
                              _isTravelActive = false;
                              _destination = null;
                              _completedTripsToday += 1;
                              _todayEarnings += 350; // Add cost share to earnings!
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Trip completed! Earnings updated.'),
                                backgroundColor: Helper.success,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _isRideStarted = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Navigation paused')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Helper.line(context)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Icon(Icons.pause, color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- ACTIONS ---

  void _openLocationPicker(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = isDark ? Colors.white : Helper.ink;
    final subtitleColor = isDark ? const Color(0xFF8E90A2) : const Color(0xFF667085);
    final barrierColor = isDark ? Colors.black87 : Colors.black45;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: bgColor,
      barrierColor: barrierColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      builder: (sheetContext) {
        final searchController = TextEditingController();

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  24 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Where are you heading?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Search bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1F25) : const Color(0xFFF2F4F7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Helper.line(context)),
                      ),
                      child: TextField(
                        controller: searchController,
                        autofocus: true,
                        cursorColor: Helper.ink,
                        decoration: InputDecoration(
                          hintText: 'Enter destination...',
                          hintStyle: TextStyle(color: subtitleColor, fontSize: 14),
                          border: InputBorder.none,
                          icon: Icon(Icons.search_rounded, color: subtitleColor),
                        ),
                        style: TextStyle(color: textColor, fontSize: 14),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            Navigator.pop(sheetContext);
                            setState(() {
                              _isTravelActive = true;
                              _destination = value.trim();
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Popular destinations',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: subtitleColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _popularDestinations.map((dest) {
                        return ActionChip(
                          label: Text(dest),
                          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF2F4F7),
                          labelStyle: TextStyle(
                            color: textColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            Navigator.pop(sheetContext);
                            setState(() {
                              _isTravelActive = true;
                              _destination = dest;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class DriverRequestsAction extends StatelessWidget {
  const DriverRequestsAction({super.key});

  @override
  Widget build(BuildContext context) {
    return const PrimaryAction(
      label: 'View requests',
      routeName: AppRoutes.jobRequests,
    );
  }
}
