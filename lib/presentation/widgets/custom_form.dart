import 'package:flutter/material.dart';
import 'package:restaurant_app/core/constants/app_theme.dart';

class CustomForm extends StatelessWidget {
  const CustomForm({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obsecureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChange,
    this.readOnly = false,
    this.maxLines,
    this.maxLength,
    this.focusNode,
    this.textInputAction,
    this.onTap,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obsecureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Function(String?)? onChange;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsecureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChange,
      readOnly: readOnly,
      maxLines: maxLines,
      maxLength: maxLength,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onTap: onTap,
      style: TextStyle(fontSize: 16, color: AppTheme.darkGrey),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppTheme.grey)
            : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppTheme.white,
        contentPadding: EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.primayColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.error),
        ),
        errorStyle: TextStyle(color: AppTheme.error),
      ),
    );
  }
}
