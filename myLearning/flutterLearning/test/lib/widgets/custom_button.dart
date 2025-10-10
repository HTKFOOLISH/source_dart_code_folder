import 'package:flutter/material.dart';

import '../core/app_export.dart';

/**
 * CustomButton - A reusable button component with customizable styling
 * 
 * This component provides a flexible button implementation that can be styled
 * with custom colors, text, padding, and dimensions while maintaining
 * responsive design principles.
 * 
 * @param text - The text to display on the button (required)
 * @param onPressed - Callback function when button is pressed (required)
 * @param backgroundColor - Background color of the button
 * @param textColor - Color of the button text
 * @param borderRadius - Border radius for rounded corners
 * @param padding - Internal padding of the button
 * @param margin - External margin around the button
 * @param width - Width of the button (null for flexible width)
 * @param fontSize - Font size of the button text
 * @param fontWeight - Font weight of the button text
 * @param isEnabled - Whether the button is enabled or disabled
 */
class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.width,
    this.fontSize,
    this.fontWeight,
    this.isEnabled = true,
  }) : super(key: key);

  /// The text to display on the button
  final String text;

  /// Callback function when button is pressed
  final VoidCallback? onPressed;

  /// Background color of the button
  final Color? backgroundColor;

  /// Color of the button text
  final Color? textColor;

  /// Border radius for rounded corners
  final double? borderRadius;

  /// Internal padding of the button
  final EdgeInsetsGeometry? padding;

  /// External margin around the button
  final EdgeInsetsGeometry? margin;

  /// Width of the button (null for flexible width)
  final double? width;

  /// Font size of the button text
  final double? fontSize;

  /// Font weight of the button text
  final FontWeight? fontWeight;

  /// Whether the button is enabled or disabled
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(bottom: 12.h, left: 4.h),
      width: width,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Color(0xFF111112),
          foregroundColor: textColor ?? Color(0xFFFFFFFF),
          padding:
              padding ?? EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10.h),
          ),
          elevation: 0,
          minimumSize: Size(double.infinity, 0),
        ),
        child: Text(
          text,
          style: TextStyleHelper.instance.bodyTextPoppins.copyWith(
            color: textColor ?? Color(0xFFFFFFFF),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
