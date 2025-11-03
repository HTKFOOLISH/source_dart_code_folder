// lib/ui/widgets/show_icon_options.dart

import 'package:flutter/material.dart';
import 'package:num_1_test/routing/app_routes.dart';
import 'package:num_1_test/state/room_provider.dart'; // Cần cho hàm reset
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowIconOptions extends StatefulWidget {
  final bool isShowMenu;
  const ShowIconOptions({super.key, required this.isShowMenu});

  @override
  State<ShowIconOptions> createState() => _ShowIconOptionsState();
}

class _ShowIconOptionsState extends State<ShowIconOptions> {
  Future<void> _showLogoutDialog(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Confirm logout',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to sign out?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Sign out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    // Xử lý logout (chỉ xóa user/pass, không xóa data phòng/thiết bị)
    if (shouldLogout == true && context.mounted) {
      final prefs = await SharedPreferences.getInstance();

      // Chỉ Xoá thông tin đăng nhập
      await prefs.remove('username'); // xoá key username
      await prefs.remove('password'); // xoá key password

      // Quay lại màn hình login
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.login, (_) => false);

      // Hiển thị dòng chữ thông báo đăng xuất thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are logged out!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 5,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            // Nút quản lý Users
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.manageUsers);
              },
              icon: const Icon(Icons.manage_accounts),
              tooltip: 'Manage Users',
            ),

            // Nút thông tin
            IconButton(
              onPressed: () {
                // TODO: Hiển thị thông tin app
              },
              icon: const Icon(Icons.info),
              tooltip: 'Info',
            ),

            // Nút Logout
            IconButton(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
            ),
          ],
        ),
      ),
    );
  }
}