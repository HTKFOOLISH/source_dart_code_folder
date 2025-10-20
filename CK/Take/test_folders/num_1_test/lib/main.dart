import 'package:flutter/material.dart';
import 'package:num_1_test/routing/app_router.dart';
import 'package:num_1_test/routing/app_routes.dart';
import 'package:num_1_test/ui/login/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Color(0xFF303030),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
          decorationColor: Colors.white,
        ),
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
      home: const LoginScreen(),
    );
  }
}
