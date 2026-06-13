import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../app/app_routes.dart';




import '../core/components/premium_inputs.dart';
import '../core/components/spott_buttons.dart';

const String _googleSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" width="20" height="20">
  <path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"/>
  <path fill="#4285F4" d="M46.5 24c0-1.61-.15-3.16-.42-4.67H24v8.86h12.69c-.55 2.94-2.22 5.43-4.73 7.11l7.36 5.7C43.62 36.88 46.5 31.02 46.5 24z"/>
  <path fill="#FBBC05" d="M10.54 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.98-6.19z"/>
  <path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.36-5.7c-2.03 1.36-4.63 2.18-8.53 2.18-6.26 0-11.57-4.22-13.46-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"/>
</svg>
''';

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
      backgroundColor: DSColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Brand Logo Mark
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: DSColors.primarySoft,
                      shape: BoxShape.circle,
                      boxShadow: DSShadows.elevation1,
                    ),
                    child: const Icon(
                      Icons.directions_car_rounded,
                      color: DSColors.primary,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'SPOTT',
                    style: DSTypography.headline.copyWith(
                      fontWeight: FontWeight.w900,
                      color: DSColors.primary,
                      letterSpacing: 3.0,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Flat Card Container for inputs
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: DSColors.surface,
                      borderRadius: BorderRadius.circular(DSRadius.card),
                      boxShadow: DSShadows.elevation1,
                      border: Border.all(color: DSColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to Spott',
                          style: DSTypography.headline.copyWith(
                            fontWeight: FontWeight.w800,
                            color: DSColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Enter your mobile number to get started.',
                          style: DSTypography.body.copyWith(
                            color: DSColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Phone input
                        PremiumTextField(
                          controller: _phoneController,
                          labelText: 'Phone Number',
                          hintText: '00000 00000',
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _requestOtp(context),
                          prefixIcon: InkWell(
                            onTap: () => _showCountryPicker(context),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '🇮🇳 +91',
                                    style: DSTypography.bodyLarge.copyWith(
                                      color: DSColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: DSColors.textSecondary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 1,
                                    height: 20,
                                    color: DSColors.border,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Continue Button
                        SpottButton.primary(
                          label: 'Continue',
                          onPressed: () => _requestOtp(context),
                        ),
                        const SizedBox(height: 16),

                        // Terms
                        Center(
                          child: Text(
                            'By continuing, you agree to our Terms of Service',
                            textAlign: TextAlign.center,
                            style: DSTypography.caption.copyWith(
                              color: DSColors.textTertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Google Sign-In Ghost Button
                  SpottButton.ghost(
                    label: 'Continue with Google',
                    icon: SvgPicture.string(
                      _googleSvg,
                      width: 20,
                      height: 20,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.chooseRole);
                    },
                  ),
                  const SizedBox(height: 32),

                  // Polished Privacy Note
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: DSColors.successSoft,
                      borderRadius: BorderRadius.circular(DSRadius.card),
                      border: Border.all(color: DSColors.success.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          color: DSColors.success,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your number stays private',
                                style: DSTypography.body.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: DSColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'We never share your contact details until your ride sharing is confirmed.',
                                style: DSTypography.caption.copyWith(
                                  color: DSColors.textSecondary,
                                  height: 1.4,
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
    );
  }

  void _showCountryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final countries = [
          {'flag': '🇮🇳', 'name': 'India', 'code': '+91'},
          {'flag': '🇺🇸', 'name': 'United States', 'code': '+1'},
          {'flag': '🇬🇧', 'name': 'United Kingdom', 'code': '+44'},
          {'flag': '🇦🇪', 'name': 'United Arab Emirates', 'code': '+971'},
          {'flag': '🇸🇬', 'name': 'Singapore', 'code': '+65'},
        ];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: DSColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Select Country Code',
                style: DSTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: DSColors.divider),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: countries.length,
                  separatorBuilder: (_, _) => const Divider(height: 1, color: DSColors.divider),
                  itemBuilder: (context, index) {
                    final country = countries[index];
                    return ListTile(
                      leading: Text(
                        country['flag']!,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(
                        country['name']!,
                        style: DSTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: DSColors.textPrimary,
                        ),
                      ),
                      trailing: Text(
                        country['code']!,
                        style: DSTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: DSColors.primary,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Selected ${country['name']} (${country['code']})'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _requestOtp(BuildContext context) {
    final phone = _phoneController.text.trim();
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid phone number'),
          backgroundColor: DSColors.primary,
        ),
      );
      return;
    }

    Navigator.pushNamed(context, AppRoutes.otp);
  }
}
