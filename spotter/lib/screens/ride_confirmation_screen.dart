import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';




import '../core/components/status_chip.dart';

class RideConfirmationScreen extends StatelessWidget {
  const RideConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final driver = ride.selectedDriver;

    return Scaffold(
      backgroundColor: DSColors.background,
      body: Column(
        children: [
          // Header
          Container(
            color: DSColors.primary,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 16, 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 22),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                    ),
                    Text(
                      'Confirm ride',
                      style: DSTypography.headline.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Trip summary card ──────────────────────────
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Trip Summary',
                              style: DSTypography.titleLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: DSColors.textPrimary,
                              ),
                            ),
                            const StatusChip(
                              label: 'Pending',
                              status: ChipStatus.pending,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Route visual
                        Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: DSColors.success,
                                  ),
                                ),
                                Container(
                                  width: 2.0,
                                  height: 32,
                                  color: DSColors.border,
                                ),
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: DSColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Pune',
                                        style: DSTypography.body.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: DSColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        '07:30 AM',
                                        style: DSTypography.body.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: DSColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Mumbai',
                                        style: DSTypography.body.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: DSColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        '01:45 PM',
                                        style: DSTypography.body.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: DSColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1, color: DSColors.divider),
                        const SizedBox(height: 16),
                        const _InfoRow(label: 'Date', value: '5 Jun 2026'),
                        const SizedBox(height: 10),
                        const _InfoRow(label: 'Seats', value: '1 seat'),
                        const SizedBox(height: 10),
                        const _InfoRow(label: 'Vehicle', value: 'Honda City (AC)'),
                        const SizedBox(height: 16),
                        const Divider(height: 1, color: DSColors.divider),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Cost Share',
                              style: DSTypography.labelLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: DSColors.textPrimary,
                              ),
                            ),
                            Text(
                              '₹700',
                              style: DSTypography.titleLarge.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: DSColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Driver card ────────────────────────────────
                  _SectionCard(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundImage: const NetworkImage(
                              'https://i.pravatar.cc/150?img=11'),
                          onBackgroundImageError: (exception, stackTrace) {},
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                driver?.name ?? 'Arjun K.',
                                style: DSTypography.body.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: DSColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Honda City • MH 12 AB 1234',
                                style: DSTypography.caption.copyWith(
                                  color: DSColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded,
                                      color: DSColors.warning, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    '4.9',
                                    style: DSTypography.caption.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: DSColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.verified_rounded,
                                      color: DSColors.info, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Verified',
                                    style: DSTypography.caption.copyWith(
                                      color: DSColors.info,
                                      fontWeight: FontWeight.bold,
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

                  const SizedBox(height: 16),

                  // ── Policy note ───────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: DSColors.warningSoft,
                      borderRadius: BorderRadius.circular(DSRadius.card),
                      border: Border.all(color: DSColors.warning.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline_rounded,
                            color: DSColors.warning, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Free cancellation within 24 hours of booking. '
                            'By proceeding, you agree to community guidelines.',
                            style: DSTypography.caption.copyWith(
                              color: DSColors.warning,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Bottom confirm bar
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: DSColors.border)),
            ),
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 14,
              bottom: MediaQuery.of(context).padding.bottom + 14,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  await ride.confirmRide();
                  if (!context.mounted) return;
                  Navigator.pushNamed(context, AppRoutes.payment);
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
                    letterSpacing: 0.6,
                  ),
                ),
                child: const Text('Pay securely'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DSColors.surface,
        borderRadius: BorderRadius.circular(DSRadius.card),
        border: Border.all(color: DSColors.border),
        boxShadow: DSShadows.elevation1,
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: DSTypography.body.copyWith(
            color: DSColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: DSTypography.body.copyWith(
            fontWeight: FontWeight.bold,
            color: DSColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
