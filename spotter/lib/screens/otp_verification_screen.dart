import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  
  int _secondsRemaining = 30;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _otpFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 30;
    });
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void _verifyOtp() {
    if (_otpController.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter the 6 digit OTP',
            style: TextStyle(fontFamily: 'Inter'),
          ),
          backgroundColor: Color(0xFFE53935),
        ),
      );
      return;
    }

    Navigator.pushNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;

    final bgColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? const Color(0xFFACACAC) : const Color(0xFF5E5E5E);
    final inputBgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF6F6F6);
    final borderColor = isDark ? const Color(0xFF2B2B2B) : const Color(0xFFEEEEEE);
    final activeBorderColor = textColor;
    final btnBgColor = isDark ? Colors.white : Colors.black;
    final btnTextColor = isDark ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.transparent,
                  child: Icon(
                    CupertinoIcons.arrow_left,
                    color: textColor,
                    size: 24,
                  ),
                ),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    
                    Text(
                      'Enter the 6-digit code',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sent to +91 98765 43210',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: subTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // OTP digit boxes
                    GestureDetector(
                      onTap: () => _otpFocusNode.requestFocus(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) {
                          final text = _otpController.text;
                          String char = '';
                          bool isCurrent = false;

                          if (index < text.length) {
                            char = text[index];
                          }
                          if (_otpFocusNode.hasFocus && index == text.length) {
                            isCurrent = true;
                          }

                          return Container(
                            width: 46,
                            height: 56,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: inputBgColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isCurrent
                                    ? activeBorderColor
                                    : borderColor,
                                width: isCurrent ? 2.0 : 1.5,
                              ),
                            ),
                            child: Text(
                              char.isNotEmpty ? char : '•',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: char.isNotEmpty
                                    ? textColor
                                    : subTextColor,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    // Hidden input field
                    SizedBox(
                      width: 0,
                      height: 0,
                      child: TextField(
                        controller: _otpController,
                        focusNode: _otpFocusNode,
                        keyboardType: TextInputType.number,
                        autofillHints: const [AutofillHints.oneTimeCode],
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        onChanged: (val) {
                          setState(() {});
                          if (val.length == 6) {
                            _verifyOtp();
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Resend link and Timer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _secondsRemaining > 0
                              ? null
                              : () {
                                  _startTimer();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'OTP resent successfully',
                                        style: TextStyle(fontFamily: 'Inter'),
                                      ),
                                      backgroundColor: isDark ? const Color(0xFF1F1F1F) : Colors.black,
                                    ),
                                  );
                                },
                          child: Text(
                            'Resend OTP',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: _secondsRemaining > 0
                                  ? subTextColor
                                  : textColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          _secondsRemaining > 0
                              ? 'Resend in ${_secondsRemaining}s'
                              : 'Ready to resend',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: _secondsRemaining > 0
                                ? subTextColor
                                : (isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706)),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Verify Button (Sticky bottom)
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 32),
              child: GestureDetector(
                onTap: _verifyOtp,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: btnBgColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Verify and Continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: btnTextColor,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
