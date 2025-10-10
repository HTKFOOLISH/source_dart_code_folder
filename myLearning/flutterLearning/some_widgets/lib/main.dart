import 'package:flutter/material.dart';
import 'package:some_widgets/constants.dart';
import 'package:some_widgets/pages/UI/loggin_page/loggin_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: kTextColor,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}
