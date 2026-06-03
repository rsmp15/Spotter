import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../custom_button.dart';
import '../custom_card.dart';
import '../helper.dart';
import '../white_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inkColor = Helper.inkColor(context);
    final mutedColor = Helper.mutedColor(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 44, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SPOTT',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: inkColor,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Text(
                    'Enter your mobile number',
                    style: TextStyle(
                      fontSize: 36,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                      color: inkColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  WhiteTextField(
                    controller: _phoneController,
                    labelText: 'Phone Number',
                    hintText: '+91 00000 00000',
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _requestOtp(context),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    label: 'Continue',
                    onPressed: () => _requestOtp(context),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'By continuing, you agree to our Terms of Service',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: mutedColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    label: 'Continue With Google',
                    isDark: false,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.chooseRole);
                    },
                  ),
                  const Spacer(),
                  CustomCard(
                    vertical: 16,
                    horizontal: 16,
                    height: 116,
                    hasShadow: false,
                    children: [
                      Text(
                        'Your number stays private',
                        style: TextStyle(
                          color: inkColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'We never share your contact until your ride is confirmed.',
                        style: TextStyle(color: mutedColor, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _requestOtp(BuildContext context) {
    final phone = _phoneController.text.trim();
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid phone number')),
      );
      return;
    }

    Navigator.pushNamed(context, AppRoutes.otp);
  }
}
