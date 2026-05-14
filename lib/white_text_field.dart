import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WhiteTextField extends StatelessWidget {
  final String labelText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? hintText;

  const WhiteTextField({
    super.key,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 66,
      child: TextField(
        keyboardType: keyboardType,
        inputFormatters:
            inputFormatters ??
            (keyboardType == TextInputType.phone ||
                    keyboardType == TextInputType.number
                ? [FilteringTextInputFormatter.digitsOnly]
                : null),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          floatingLabelBehavior: FloatingLabelBehavior.auto,

          labelStyle: const TextStyle(color: Color(0xFF8A8A8A), fontSize: 16),

          floatingLabelStyle: const TextStyle(
            color: Color(0xFF8A8A8A),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),

          filled: true,
          fillColor: Colors.white,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5E5E5), width: 2),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5E5E5), width: 2),
          ),
        ),
      ),
    );
  }
}
