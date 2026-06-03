import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../custom_button.dart';
import '../custom_card.dart';
import '../helper.dart';
import '../white_text_field.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
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
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: Icon(Icons.arrow_back, color: inkColor),
                    style: IconButton.styleFrom(
                      backgroundColor: Helper.cardBg(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                        side: BorderSide(color: Helper.line(context)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    'Verify your number',
                    style: TextStyle(
                      fontSize: 36,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                      color: inkColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'OTP sent to +91 98765 43210',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: mutedColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  WhiteTextField(
                    controller: _otpController,
                    labelText: '6 Digit OTP',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _verifyOtp(context),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    label: 'Verify And Continue',
                    onPressed: () => _verifyOtp(context),
                  ),
                  const SizedBox(height: 80),
                  CustomCard(
                    vertical: 16,
                    horizontal: 16,
                    height: 104,
                    hasShadow: false,
                    children: [
                      Text(
                        'Did not receive the OTP?',
                        style: TextStyle(
                          color: inkColor,
                          fontWeight: FontWeight.w500,
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
                            child: Text(
                              'Resend OTP',
                              style: TextStyle(
                                color: inkColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(
                            'Expires in 00:30',
                            style: TextStyle(
                              color: mutedColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
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
        ),
      ),
    );
  }

  void _verifyOtp(BuildContext context) {
    if (_otpController.text.trim().length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter the 6 digit OTP')));
      return;
    }

    Navigator.pushNamed(context, AppRoutes.chooseRole);
  }
}
