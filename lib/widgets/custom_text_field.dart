import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool enabled;
  final VoidCallback? onTap;
  final bool readOnly;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.maxLines = 1,
    this.enabled = true,
    this.onTap,
    this.readOnly = false,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      enabled: enabled,
      onTap: onTap,
      readOnly: readOnly,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: enabled ? AppColors.darkGray : AppColors.mediumGray,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: prefixIcon != null 
            ? Icon(prefixIcon, color: AppColors.mediumGray) 
            : null,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.teal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.mediumGray),
        ),
        filled: true,
        fillColor: enabled ? AppColors.softWhite : AppColors.lightGray.withOpacity(0.5),
        labelStyle: TextStyle(
          color: enabled ? AppColors.mediumGray : AppColors.mediumGray.withOpacity(0.6),
        ),
        hintStyle: TextStyle(
          color: AppColors.mediumGray.withOpacity(0.7),
        ),
        errorStyle: const TextStyle(
          color: AppColors.error,
          fontSize: 12,
        ),
      ),
    );
  }
}
