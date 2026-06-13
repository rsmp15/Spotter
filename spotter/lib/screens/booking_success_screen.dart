import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import 'package:spotter/design_system/design_system.dart';

class BookingSuccessScreen extends StatefulWidget {
  const BookingSuccessScreen({super.key});

  @override
  State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnim = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: DSColors.primary,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                children: const [
                  Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Booking Confirmed!',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Animated success checkmark
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: ScaleTransition(
                        scale: _scaleAnim,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: DSColors.success.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: DSColors.success.withValues(alpha: 0.3),
                                width: 2),
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: DSColors.success,
                            size: 54,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'You\'re all set!',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: DSColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Your ride has been booked successfully.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: DSColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Ticket-style booking card
                    _buildTicket(),

                    const SizedBox(height: 20),

                    // Tracking info
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: DSColors.info.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(DSRadius.lg),
                        border: Border.all(
                            color: DSColors.info.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_rounded,
                              color: DSColors.info, size: 18),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Live tracking will be available 30 min before departure.',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: DSColors.info,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom actions
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).padding.bottom + 12,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.tracking),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DSColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(DSRadius.md),
                        ),
                      ),
                      child: const Text(
                        'VIEW TRIP DETAILS',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                        (route) => false,
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: DSColors.primary,
                        side: const BorderSide(color: DSColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(DSRadius.md),
                        ),
                      ),
                      child: const Text(
                        'BACK TO HOME',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
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

  // Redbus-style ticket
  Widget _buildTicket() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DSRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Ticket header
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: DSColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(DSRadius.xl),
                topRight: Radius.circular(DSRadius.xl),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking ID',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      '#SPT20260605',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'CONFIRMED',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Notch separator
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: DSColors.background,
                  shape: BoxShape.circle,
                ),
                transform:
                    Matrix4.translationValues(-9, 0, 0),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (_, constraints) => Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      (constraints.constrainWidth() / 8).round(),
                      (_) => Container(
                        width: 4,
                        height: 1,
                        color: DSColors.divider,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: DSColors.background,
                  shape: BoxShape.circle,
                ),
                transform:
                    Matrix4.translationValues(9, 0, 0),
              ),
            ],
          ),

          // Ticket body
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                // Route
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Pune',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: DSColors.textPrimary,
                          ),
                        ),
                        Text(
                          '07:30 AM',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: DSColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_rounded,
                        color: DSColors.textTertiary, size: 20),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      children: const [
                        Text(
                          'Mumbai',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: DSColors.textPrimary,
                          ),
                        ),
                        Text(
                          '01:45 PM',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: DSColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: DSColors.divider),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: _TicketInfoCell(
                            label: 'Date', value: '5 Jun 2026')),
                    Container(
                        width: 1,
                        height: 32,
                        color: DSColors.divider),
                    Expanded(
                        child: _TicketInfoCell(
                            label: 'Seats', value: '1 Seat')),
                    Container(
                        width: 1,
                        height: 32,
                        color: DSColors.divider),
                    Expanded(
                        child: _TicketInfoCell(
                            label: 'Total', value: 'â‚¹700')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketInfoCell extends StatelessWidget {
  final String label;
  final String value;
  const _TicketInfoCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            color: DSColors.textTertiary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: DSColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
