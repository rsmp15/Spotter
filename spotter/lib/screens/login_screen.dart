import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _countryCode = '+91';
  String _countryFlag = '🇮🇳';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _showCountryPicker(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final dividerColor = isDark ? const Color(0xFF222222) : const Color(0xFFEEEEEE);
    final textColor = isDark ? Colors.white : Colors.black;

    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
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
                  color: isDark ? const Color(0xFF3D3D3D) : const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Select Country Code',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              Divider(height: 1, color: dividerColor),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: countries.length,
                  separatorBuilder: (_, _) => Divider(height: 1, color: dividerColor),
                  itemBuilder: (context, index) {
                    final country = countries[index];
                    return ListTile(
                      leading: Text(
                        country['flag']!,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(
                        country['name']!,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      trailing: Text(
                        country['code']!,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _countryCode = country['code']!;
                          _countryFlag = country['flag']!;
                        });
                        Navigator.pop(context);
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

  void _requestOtp() {
    final phone = _phoneController.text.trim();
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter a valid phone number',
            style: TextStyle(fontFamily: 'Inter'),
          ),
          backgroundColor: Color(0xFFE53935),
        ),
      );
      return;
    }

    Navigator.pushNamed(context, AppRoutes.otp);
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;
    
    final bgColor = isDark ? const Color(0xFF000000) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? const Color(0xFFAFAFAF) : const Color(0xFF767676);
    final inputBgColor = isDark ? const Color(0xFF222222) : const Color(0xFFF3F3F3);
    final borderColor = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE2E2E2);
    final btnBgColor = isDark ? Colors.white : Colors.black;
    final btnTextColor = isDark ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Back navigation arrow
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
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
                    
                    // Title
                    Text(
                      "Enter your mobile number",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Phone input field wrapper
                    Container(
                      decoration: BoxDecoration(
                        color: inputBgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          // Country selector
                          GestureDetector(
                            onTap: () => _showCountryPicker(context),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                              child: Row(
                                children: [
                                  Text(
                                    '$_countryFlag $_countryCode',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    CupertinoIcons.chevron_down,
                                    color: subTextColor,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Vertical divider
                          Container(
                            width: 1.5,
                            height: 28,
                            color: borderColor,
                          ),
                          
                          // Text Field
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                              onSubmitted: (_) => _requestOtp(),
                              decoration: InputDecoration(
                                hintText: '00000 00000',
                                hintStyle: TextStyle(
                                  fontFamily: 'Inter',
                                  color: subTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Legal Disclaimer
                    Text(
                      'By proceeding, you consent to receive text messages (including WhatsApp) from SPOTT. Message and data rates may apply.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: subTextColor,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Continue Pill Button (Sticky bottom)
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 32),
              child: GestureDetector(
                onTap: _requestOtp,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: btnBgColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Continue',
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
