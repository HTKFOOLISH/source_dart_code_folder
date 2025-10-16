import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_image_view.dart';
import 'widgets/room_card_widget.dart';

class AllRoomsScreen extends StatelessWidget {
  AllRoomsScreen({Key? key}) : super(key: key);

  // Sample data for rooms
  final List<Map<String, dynamic>> roomsData = [
    {
      "title": "Living Room",
      "icon": ImageConstant.imgLivingRoom1,
      "powerIcon": ImageConstant.imgPower,
    },
    {
      "title": "Bed room",
      "icon": ImageConstant.imgBed21,
      "powerIcon": ImageConstant.imgPower,
    },
    {
      "title": "Kitchen",
      "icon": ImageConstant.imgKitchen1,
      "powerIcon": ImageConstant.imgPower,
    },
    {
      "title": "Parking",
      "icon": ImageConstant.imgCar1,
      "powerIcon": ImageConstant.imgPower,
    },
    {
      "title": "Garden",
      "icon": ImageConstant.imgVectorWhiteA70064x50,
      "powerIcon": ImageConstant.imgPower,
    },
    {
      "title": "Reading Room",
      "icon": ImageConstant.imgVectorWhiteA70038x64,
      "powerIcon": ImageConstant.imgPower,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray_900_01,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(48.h),
        child: CustomAppBar(
          title: 'Back',
          backgroundColor: appTheme.gray_900_01,
          titleColor: appTheme.white_A700,
          backButtonIcon: ImageConstant.imgIcRoundArrowBack,
          backButtonColor: appTheme.white_A700,
          onBackPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.h),
        child: Column(
          spacing: 42.h,
          children: [_buildHeaderSection(context), _buildRoomsGrid(context)],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.h, right: 22.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Rooms',
                  style: TextStyleHelper.instance.headline24SemiBoldPoppins
                      .copyWith(height: 1.5),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: CustomImageView(
              imagePath: ImageConstant.imgVectorWhiteA700,
              height: 42.h,
              width: 42.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomsGrid(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 2.h),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.h,
            mainAxisSpacing: 16.h,
            childAspectRatio: 0.9,
          ),
          itemCount: roomsData.length,
          itemBuilder: (context, index) {
            return RoomCardWidget(
              title: roomsData[index]['title'],
              iconPath: roomsData[index]['icon'],
              powerIconPath: roomsData[index]['powerIcon'],
              onTap: () {
                // Handle room card tap
              },
            );
          },
        ),
      ),
    );
  }
}
