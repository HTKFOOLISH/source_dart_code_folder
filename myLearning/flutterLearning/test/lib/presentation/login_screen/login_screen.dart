import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_edit_text.dart';
import '../../widgets/custom_image_view.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray_900_01,
      body: Container(
        decoration: BoxDecoration(
          color: appTheme.gray_900_01,
          boxShadow: [
            BoxShadow(
              color: appTheme.black_900_7f,
              offset: Offset(10, 20),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: 52.h, right: 12.h, left: 12.h),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 210.h,
                          right: 20.h,
                          left: 20.h,
                        ),
                        width: double.infinity,
                        height: 168.h,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.46,
                                    height: 150.h,
                                    padding: EdgeInsets.only(
                                      bottom: 24.h,
                                      left: 34.h,
                                    ),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          ImageConstant.imgGroup121,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        CustomImageView(
                                          imagePath: ImageConstant.imgImage3,
                                          width: 62.h,
                                          height: 62.h,
                                          fit: BoxFit.cover,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 40.h),
                                    child: CustomImageView(
                                      imagePath: ImageConstant.imgVector,
                                      width: 46.h,
                                      height: 28.h,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 55.h,
                              right: 0,
                              child: Text(
                                'BUG HOME',
                                style: TextStyleHelper
                                    .instance
                                    .headline35SemiBoldPoppins
                                    .copyWith(height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomEditText(
                              placeholder: "Username",
                              controller: usernameController,
                              validator: _validateUsername,
                              margin: EdgeInsets.only(top: 36.h),
                            ),
                            CustomEditText(
                              placeholder: "Password",
                              isPassword: true,
                              controller: passwordController,
                              validator: _validatePassword,
                              margin: EdgeInsets.only(top: 22.h),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.h, left: 10.h),
              child: Column(
                children: [
                  CustomButton(
                    text: 'Login',
                    onPressed: () => _onLoginPressed(context),
                    backgroundColor: appTheme.gray_900,
                    textColor: appTheme.white_A700,
                    borderRadius: 10.h,
                    fontSize: 36.fSize,
                    fontWeight: FontWeight.w400,
                    padding: EdgeInsets.symmetric(
                      vertical: 20.h,
                      horizontal: 30.h,
                    ),
                    margin: EdgeInsets.only(bottom: 12.h, left: 4.h),
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateUsername(String? value) {
    if (value?.isEmpty ?? true) {
      return "Username is required";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value?.isEmpty ?? true) {
      return "Password is required";
    }
    if (value!.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      // Form is valid, process login
      _showLoginSuccess(context);

      // Clear form fields
      usernameController.clear();
      passwordController.clear();

      // Navigate to all rooms screen
      Navigator.of(context).pushReplacementNamed(AppRoutes.allRoomsScreen);
    }
  }

  void _showLoginSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login successful!'),
        backgroundColor: appTheme.greenCustom,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
