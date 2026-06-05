import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../core/components/redbus_sections.dart';
import '../core/theme/redbus_theme.dart';
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
    return Scaffold(
      backgroundColor: RBColors.background,
      body: Column(
        children: [
          // Top Brand Hero Section (Brand Red Gradient)
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [RBColors.primary, Color(0xFFB73D45)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'SPOTT',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Enter your mobile number',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // RedBus style wave transition
          const RBWaveSeparator(
            topColor: RBColors.primary,
            bottomColor: Colors.white,
            height: 24,
          ),

          // Bottom Content Section (White Background)
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WhiteTextField(
                          controller: _phoneController,
                          labelText: 'Phone Number',
                          hintText: '+91 00000 00000',
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _requestOtp(context),
                        ),
                        const SizedBox(height: 20),
                        
                        // Primary Continue Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => _requestOtp(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: RBColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(RBRadius.md),
                              ),
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Terms disclaimer
                        const Center(
                          child: Text(
                            'By continuing, you agree to our Terms of Service',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: RBColors.textMedium,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Google sign-in (ghost button style)
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.chooseRole);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: RBColors.textDark,
                              side: const BorderSide(color: RBColors.divider),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(RBRadius.md),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.g_mobiledata_rounded, size: 28),
                                SizedBox(width: 4),
                                Text(
                                  'Continue With Google',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Privacy notification card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: RBColors.surfaceGrey,
                            borderRadius: BorderRadius.circular(RBRadius.lg),
                            border: Border.all(color: RBColors.divider),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.lock_outline_rounded,
                                  color: RBColors.green, size: 20),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Your number stays private',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: RBColors.textDark,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'We never share your contact until your ride is confirmed.',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 11,
                                        color: RBColors.textMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _requestOtp(BuildContext context) {
    final phone = _phoneController.text.trim();
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid phone number'),
          backgroundColor: RBColors.primary,
        ),
      );
      return;
    }

    Navigator.pushNamed(context, AppRoutes.otp);
  }
}

