import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffix,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      enabled: enabled,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppT.c.textMuted)
            : null,
        suffixIcon: suffix,
      ),
    );
  }
}
