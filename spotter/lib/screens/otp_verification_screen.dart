import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../app/app_routes.dart';




import '../core/components/spott_buttons.dart';

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
    // Auto-focus OTP field after a short delay
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DSColors.background,
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
                    icon: const Icon(Icons.arrow_back, color: DSColors.textPrimary),
                    style: IconButton.styleFrom(
                      backgroundColor: DSColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                        side: const BorderSide(color: DSColors.border),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    'Verify your number',
                    style: DSTypography.displayLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: DSColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'OTP sent to +91 98765 43210',
                    style: DSTypography.body.copyWith(
                      color: DSColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 6-digit verification code layout
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
                          width: 50,
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: DSColors.surface,
                            borderRadius: BorderRadius.circular(DSRadius.md),
                            border: Border.all(
                              color: isCurrent
                                  ? DSColors.primary
                                  : DSColors.border,
                              width: isCurrent ? 2.0 : 1.0,
                            ),
                            boxShadow: isCurrent ? DSShadows.elevation2 : null,
                          ),
                          child: Text(
                            char.isNotEmpty ? char : '•',
                            style: DSTypography.headline.copyWith(
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.bold,
                              color: char.isNotEmpty
                                  ? DSColors.textPrimary
                                  : DSColors.textMuted,
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
                          _verifyOtp(context);
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Verify Button
                  SpottButton.primary(
                    label: 'Verify and Continue',
                    onPressed: () => _verifyOtp(context),
                  ),

                  const SizedBox(height: 48),

                  // Timer & Resend Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: DSColors.surface,
                      borderRadius: BorderRadius.circular(DSRadius.card),
                      border: Border.all(color: DSColors.border),
                      boxShadow: DSShadows.elevation1,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Did not receive the OTP?',
                          style: DSTypography.body.copyWith(
                            color: DSColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: _secondsRemaining > 0
                                  ? null
                                  : () {
                                      _startTimer();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('OTP resent successfully'),
                                          backgroundColor: DSColors.success,
                                        ),
                                      );
                                    },
                              child: Text(
                                'Resend OTP',
                                style: DSTypography.body.copyWith(
                                  color: _secondsRemaining > 0
                                      ? DSColors.border
                                      : DSColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              _secondsRemaining > 0
                                  ? 'Expires in 00:${_secondsRemaining.toString().padLeft(2, '0')}'
                                  : 'Code expired',
                              style: DSTypography.caption.copyWith(
                                color: _secondsRemaining > 0
                                    ? DSColors.textSecondary
                                    : DSColors.danger,
                                fontWeight: _secondsRemaining > 0
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
      ).showSnackBar(const SnackBar(
        content: Text('Enter the 6 digit OTP'),
        backgroundColor: DSColors.danger,
      ));
      return;
    }

    Navigator.pushNamed(context, AppRoutes.chooseRole);
  }
}
