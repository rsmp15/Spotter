import 'package:flutter/material.dart';
import 'package:spotter/custom_card.dart';
import 'package:spotter/helper.dart';

import '../app/app_routes.dart';
import '../custom_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.backgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SPOTT',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Helper.ink,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Share your journey with Spott',
                    style: TextStyle(
                      fontSize: 36,
                      height: 1.12,
                      fontWeight: FontWeight.w700,
                      color: Helper.ink,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    height: 230,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEFEF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Helper.lineColor),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(painter: _SpottRoutePainter()),
                        ),
                        const Center(
                          child: Icon(
                            Icons.near_me,
                            size: 74,
                            color: Helper.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Reduce travel costs by sharing seats on trips you\'re already making.',
                    style: TextStyle(
                      color: Helper.muted,
                      fontSize: 16,
                      height: 1.45,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  const CustomCard(
                    height: 154,
                    hasShadow: false,
                    children: [
                      Text(
                        'Search intercity trips and travel at a fraction of the cost',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Helper.ink,
                        ),
                      ),
                      Text(
                        'Find your route match with verified travelers',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Helper.ink,
                        ),
                      ),
                      Text(
                        'Send parcels same-day through travelers on their way',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Helper.ink,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const CustomButton(routeName: AppRoutes.login),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpottRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(size.width * 0.14, size.height * 0.68)
      ..cubicTo(
        size.width * 0.34,
        size.height * 0.28,
        size.width * 0.64,
        size.height * 0.88,
        size.width * 0.86,
        size.height * 0.34,
      );
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = Helper.ink;
    canvas.drawCircle(
      Offset(size.width * 0.14, size.height * 0.68),
      7,
      dotPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width * 0.86, size.height * 0.34),
        width: 14,
        height: 14,
      ),
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
