import 'package:flutter/material.dart';
import 'package:spotter/app/app_routes.dart';
import 'package:spotter/helper.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.darkBackground,
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Center(
              child: Container(
                alignment: Alignment.center,
                height: 150,
                width: 150,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1A1A1A),
                ),
                child: const Text('Spotter', style: Helper.titleStyle),
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(left: 40),
              child: Text(
                'Go anywhere,\nanytime.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text(
                'Reliable rides at your fingertips - \nautos, cabs and more.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.onboarding);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                alignment: Alignment.center,
                height: 56,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xff1A1A1A),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
