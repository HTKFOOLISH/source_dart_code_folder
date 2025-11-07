// my_app.dart

import 'package:flutter/material.dart';

import 'routing/app_router.dart';
import 'routing/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ##### PHẦN SỬA #####
    // Đã di chuyển colorScheme ra ngoài để dễ dùng
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blueGrey,
      brightness: Brightness.dark, // Đổi thành .dark để hợp với theme của bạn
    );

    return MaterialApp(
      onGenerateRoute: onGenerateRoute, // <- dùng router tự viết
      initialRoute: AppRoutes.login, // <- trang bắt đầu
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF303030), // màu nền
          foregroundColor: Colors.white, // màu chữ và icon
          elevation: 0,
          centerTitle: true, // căn giữa tiêu đề
          toolbarHeight: 80, // độ cao
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        fontFamily: 'Poppins',
        colorScheme: colorScheme, // Sử dụng colorScheme đã khai báo
        scaffoldBackgroundColor: Color(0xFF303030),
        textTheme: ThemeData.dark().textTheme.apply(
          // Dùng ThemeData.dark()
          bodyColor: Colors.white,
          displayColor: Colors.white,
          decorationColor: Colors.white,
        ),

        // ##### PHẦN SỬA #####
        // floatingActionButtonTheme phải nằm TRONG ThemeData
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          extendedPadding: EdgeInsetsGeometry.all(17),
          backgroundColor: Color(0xFF303030),
          foregroundColor: Colors.white,
          hoverColor: Colors.blue,
          hoverElevation: 50,
          elevation: 0,
          focusColor: Colors.white70,
          focusElevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(21),
            side: BorderSide(color: Colors.white, width: 3),
          ),
        ),

        // ##### KẾT THÚC PHẦN SỬA #####
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.onSurface,
            foregroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45),
              side: BorderSide(color: Colors.white, width: 3),
            ),
          ),
        ),
        listTileTheme: ListTileThemeData(
          tileColor: Colors.black,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            side: BorderSide(color: Colors.white60, width: 3),
          ),
        ),
      ),
    );
  }
}
