import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../custom_button.dart';
import '../custom_card.dart';
import '../white_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                'Enter Your Number',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'We will send an OTP to verify.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              const WhiteTextField(
                labelText: 'Phone Number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              const CustomButton(label: 'Get OTP', routeName: AppRoutes.otp),
              const SizedBox(height: 20),
              CustomButton(
                label: 'Continue With Google',
                isDark: false,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Google sign-in coming soon')),
                  );
                },
              ),
              const Spacer(),
              const CustomCard(
                vertical: 20,
                horizontal: 20,
                children: [
                  Text(
                    'Your Number Stays Private',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'We never share your contact with drivers until your ride is confirmed.',
                    style: TextStyle(color: Color(0xFF757575), fontSize: 15),
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
