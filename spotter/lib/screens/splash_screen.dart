import 'package:flutter/material.dart';
import 'package:spotter/app/app_routes.dart';
import 'package:spotter/helper.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: Container(
                alignment: Alignment.center,
                height: 190,
                width: 190,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Helper.lineColor),
                ),
                child: const Text(
                  'SPOTT',
                  style: TextStyle(
                    color: Helper.ink,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
              ),
            ),
            const Spacer(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Go anywhere\nwith Spott',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 32,
                  height: 1.05,
                  fontWeight: FontWeight.w700,
                  color: Helper.ink,
                  fontFamily: 'Inter',
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Rides, rentals, parking and city mobility in one place.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.35,
                  color: Helper.muted,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const Spacer(),

            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.onboarding);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                alignment: Alignment.center,
                height: 56,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Helper.ink,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
