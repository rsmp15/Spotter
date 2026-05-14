import 'package:flutter/material.dart';
import 'package:spotter/custom_card.dart';

import '../app/app_routes.dart';
import '../custom_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rides Made Easy',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Quick, safe and affordable travel.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffE8EDF2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.route, size: 72),
              ),
              const SizedBox(height: 25),
              const Text(
                'Where to go?',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Cars, autos, bikes - matched to your route \nin seconds.',
                style: TextStyle(color: Color(0xFF757575), fontSize: 15),
              ),
              const Spacer(),
              const CustomCard(
                children: [
                  Text(
                    'Real-Time GPS Tracking',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Verified driver profiles with ratings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Cashless UPI, card and wallet pay',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
    );
  }
}
