import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../custom_button.dart';
import '../custom_card.dart';
import '../white_text_field.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

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
                'Verify Your Number',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'OTP sent to +91 98765 43210',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              const WhiteTextField(
                labelText: '6 Digit OTP',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              const CustomButton(
                label: 'Verify And Continue',
                routeName: AppRoutes.home,
              ),
              const SizedBox(height: 80),
              CustomCard(
                vertical: 15,
                horizontal: 15,
                children: [
                  const Text(
                    'Did not receive the OTP?',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('OTP resent')),
                          );
                        },
                        child: const Text(
                          'Resend OTP',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Text(
                        'Expires in 00:30',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
