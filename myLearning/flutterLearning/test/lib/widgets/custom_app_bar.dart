import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * CustomAppBar - A reusable AppBar component with customizable back button and title
 * 
 * Features:
 * - Configurable title text and styling
 * - Optional back button with custom icon
 * - Customizable colors and background
 * - Responsive design using SizeUtils
 * - Support for custom actions
 * 
 * @param title - The title text to display
 * @param backgroundColor - Background color of the AppBar
 * @param titleColor - Color of the title text
 * @param showBackButton - Whether to show the back button
 * @param backButtonIcon - Custom back button icon path
 * @param backButtonColor - Color of the back button icon
 * @param onBackPressed - Callback for back button press
 * @param actions - List of action widgets
 * @param height - Custom height for the AppBar
 */
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    this.title,
    this.backgroundColor,
    this.titleColor,
    this.showBackButton,
    this.backButtonIcon,
    this.backButtonColor,
    this.onBackPressed,
    this.actions,
    this.height,
  }) : super(key: key);

  /// The title text to display in the AppBar
  final String? title;

  /// Background color of the AppBar
  final Color? backgroundColor;

  /// Color of the title text
  final Color? titleColor;

  /// Whether to show the back button (defaults to true if not specified)
  final bool? showBackButton;

  /// Custom back button icon path
  final String? backButtonIcon;

  /// Color of the back button icon
  final Color? backButtonColor;

  /// Callback function when back button is pressed
  final VoidCallback? onBackPressed;

  /// List of action widgets to display on the right
  final List<Widget>? actions;

  /// Custom height for the AppBar
  final double? height;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? appTheme.transparentCustom,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: _buildLeading(context),
      title: _buildTitle(),
      actions: actions,
      titleSpacing: showBackButton ?? true ? 0 : 16.h,
    );
  }

  /// Builds the leading widget (back button with text)
  Widget? _buildLeading(BuildContext context) {
    if (showBackButton == false) return null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 12.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onBackPressed ?? () => Navigator.of(context).pop(),
            child: CustomImageView(
              imagePath: backButtonIcon ?? ImageConstant.imgIcRoundArrowBack,
              height: 24.h,
              width: 24.h,
              color: backButtonColor ?? appTheme.whiteCustom,
            ),
          ),
          if (title != null) ...[
            SizedBox(width: 16.h),
            Flexible(
              child: Text(
                title!,
                style: TextStyleHelper.instance.body14MediumPoppins.copyWith(
                  color: titleColor ?? appTheme.whiteCustom,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds the title widget when not using back button
  Widget? _buildTitle() {
    if (showBackButton != false || title == null) return null;

    return Text(
      title!,
      style: TextStyleHelper.instance.body14MediumPoppins.copyWith(
        color: titleColor ?? appTheme.whiteCustom,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 48.h);
}
