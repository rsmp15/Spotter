import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../app/app_routes.dart';
import '../core/theme/colors.dart';
import '../core/theme/radius.dart';
import '../core/theme/shadows.dart';
import '../core/theme/typography.dart';
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
      backgroundColor: SpottColors.background,
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
                    icon: const Icon(Icons.arrow_back, color: SpottColors.textPrimary),
                    style: IconButton.styleFrom(
                      backgroundColor: SpottColors.surface1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                        side: const BorderSide(color: SpottColors.border),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    'Verify your number',
                    style: SpottTextStyles.displayLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: SpottColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'OTP sent to +91 98765 43210',
                    style: SpottTextStyles.body.copyWith(
                      color: SpottColors.textSecondary,
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
                            color: SpottColors.surface1,
                            borderRadius: BorderRadius.circular(SpottRadius.md),
                            border: Border.all(
                              color: isCurrent
                                  ? SpottColors.primary
                                  : SpottColors.border,
                              width: isCurrent ? 2.0 : 1.0,
                            ),
                            boxShadow: isCurrent ? SpottShadows.glowPrimary : null,
                          ),
                          child: Text(
                            char.isNotEmpty ? char : '•',
                            style: SpottTextStyles.display.copyWith(
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.bold,
                              color: char.isNotEmpty
                                  ? SpottColors.textPrimary
                                  : SpottColors.textMuted,
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
                      color: SpottColors.surface1,
                      borderRadius: BorderRadius.circular(SpottRadius.card),
                      border: Border.all(color: SpottColors.border),
                      boxShadow: SpottShadows.elevation1,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Did not receive the OTP?',
                          style: SpottTextStyles.body.copyWith(
                            color: SpottColors.textPrimary,
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
                                          backgroundColor: SpottColors.success,
                                        ),
                                      );
                                    },
                              child: Text(
                                'Resend OTP',
                                style: SpottTextStyles.body.copyWith(
                                  color: _secondsRemaining > 0
                                      ? SpottColors.disabledText
                                      : SpottColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              _secondsRemaining > 0
                                  ? 'Expires in 00:${_secondsRemaining.toString().padLeft(2, '0')}'
                                  : 'Code expired',
                              style: SpottTextStyles.caption.copyWith(
                                color: _secondsRemaining > 0
                                    ? SpottColors.textSecondary
                                    : SpottColors.danger,
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
        backgroundColor: SpottColors.danger,
      ));
      return;
    }

    Navigator.pushNamed(context, AppRoutes.chooseRole);
  }
}
