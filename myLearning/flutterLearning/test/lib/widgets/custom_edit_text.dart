import 'package:flutter/material.dart';

import '../core/app_export.dart';

/**
 * CustomEditText - A flexible and reusable text input field component
 * 
 * This component provides a styled text input field that can handle both regular text
 * and password inputs with built-in validation support and responsive design.
 * 
 * @param placeholder - The hint text displayed when the field is empty
 * @param isPassword - Whether this is a password field (enables text obscuring)
 * @param controller - TextEditingController for managing the input text
 * @param validator - Function to validate the input text
 * @param keyboardType - The type of keyboard to display
 * @param onChanged - Callback function triggered when text changes
 * @param margin - External spacing around the component
 */
class CustomEditText extends StatefulWidget {
  const CustomEditText({
    super.key,
    this.placeholder,
    this.isPassword,
    this.controller,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.margin,
  });

  /// Hint text displayed when the field is empty
  final String? placeholder;

  /// Whether this is a password field (enables text obscuring and toggle icon)
  final bool? isPassword;

  /// Controller for managing the text input
  final TextEditingController? controller;

  /// Validation function for the input
  final String? Function(String?)? validator;

  /// Keyboard type to display
  final TextInputType? keyboardType;

  /// Callback triggered when text changes
  final Function(String)? onChanged;

  /// External margin around the component
  final EdgeInsets? margin;

  @override
  State<CustomEditText> createState() => _CustomEditTextState();
}

class _CustomEditTextState extends State<CustomEditText> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final isPasswordField = widget.isPassword ?? false;

    return Container(
      margin: widget.margin ?? EdgeInsets.only(top: 22.h),
      child: TextFormField(
        controller: widget.controller,
        obscureText: isPasswordField ? !_isPasswordVisible : false,
        keyboardType:
            widget.keyboardType ??
            (isPasswordField
                ? TextInputType.visiblePassword
                : TextInputType.text),
        validator: widget.validator,
        onChanged: widget.onChanged,
        style: TextStyleHelper.instance.title18RegularPoppins,
        decoration: InputDecoration(
          hintText: widget.placeholder ?? "Enter text",
          hintStyle: TextStyleHelper.instance.title18RegularPoppins,
          filled: true,
          fillColor: appTheme.gray_300,
          contentPadding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 14.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.h),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.h),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.h),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.h),
            borderSide: BorderSide(color: appTheme.redCustom, width: 1.h),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.h),
            borderSide: BorderSide(color: appTheme.redCustom, width: 1.h),
          ),
          suffixIcon: isPasswordField
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: appTheme.black_900_7f,
                    size: 20.h,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
