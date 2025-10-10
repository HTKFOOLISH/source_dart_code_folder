import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

import '../../../widgets/custom_image_view.dart';

class RoomCardWidget extends StatelessWidget {
  final String title;
  final String iconPath;
  final String powerIconPath;
  final VoidCallback? onTap;

  RoomCardWidget({
    Key? key,
    required this.title,
    required this.iconPath,
    required this.powerIconPath,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.h)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: CustomImageView(
                  imagePath: iconPath,
                  height: 64.h,
                  width: 64.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyleHelper.instance.body14MediumPoppins
                        .copyWith(color: appTheme.white_A700, height: 1.5),
                  ),
                ),
                CustomImageView(
                  imagePath: powerIconPath,
                  height: 16.h,
                  width: 16.h,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
