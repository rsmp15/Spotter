import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../core/theme/radius.dart';
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
    return GlassScaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(SpottSpacing.lg, 44, SpottSpacing.lg, SpottSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SPOTT',
                    style: SpottTextStyles.headline.copyWith(
                      color: SpottColors.primary,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: SpottSpacing.xl),
                  Text(
                    'Enter your mobile number',
                    style: SpottTextStyles.display.copyWith(
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: SpottSpacing.xl),
                  WhiteTextField(
                    controller: _phoneController,
                    labelText: 'Phone Number',
                    hintText: '+91 00000 00000',
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _requestOtp(context),
                  ),
                  const SizedBox(height: SpottSpacing.lg),
                  SpottButton.primary(
                    label: 'Continue',
                    onPressed: () => _requestOtp(context),
                  ),
                  const SizedBox(height: SpottSpacing.md),
                  Center(
                    child: Text(
                      'By continuing, you agree to our Terms of Service',
                      textAlign: TextAlign.center,
                      style: SpottTextStyles.caption.copyWith(
                        color: SpottColors.textTertiary,
                      ),
                    ),
                  ),
                  const SizedBox(height: SpottSpacing.lg),
                  SpottButton.ghost(
                    label: 'Continue With Google',
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.chooseRole);
                    },
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(SpottSpacing.md),
                    decoration: BoxDecoration(
                      color: SpottColors.surface2,
                      borderRadius: BorderRadius.circular(SpottRadius.card),
                      border: Border.all(color: SpottColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_outline_rounded, color: SpottColors.success),
                        const SizedBox(width: SpottSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Your number stays private', style: SpottTextStyles.label),
                              const SizedBox(height: 2),
                              Text(
                                'We never share your contact until your ride is confirmed.',
                                style: SpottTextStyles.caption,
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
    );
  }

  void _requestOtp(BuildContext context) {
    final phone = _phoneController.text.trim();
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid phone number'),
          backgroundColor: SpottColors.danger,
        ),
      );
      return;
    }

    Navigator.pushNamed(context, AppRoutes.otp);
  }
}
