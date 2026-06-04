import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotter/helper.dart';

class WhiteTextField extends StatelessWidget {
  final String labelText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final int maxLines;

  const WhiteTextField({
    super.key,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      height: maxLines == 1 ? 66 : null,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        maxLines: maxLines,
        inputFormatters:
            inputFormatters ??
            (keyboardType == TextInputType.phone ||
                    keyboardType == TextInputType.number
                ? [FilteringTextInputFormatter.digitsOnly]
                : null),
        style: TextStyle(color: Helper.inkColor(context), fontSize: 16),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          floatingLabelBehavior: FloatingLabelBehavior.auto,

          labelStyle: TextStyle(
            color: Helper.mutedColor(context),
            fontSize: 16,
          ),

          floatingLabelStyle: TextStyle(
            color: Helper.mutedColor(context),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),

          filled: true,
          fillColor: Helper.canvasSofterColor(context),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isDark ? Colors.white : Helper.ink,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
