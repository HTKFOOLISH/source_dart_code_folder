// lib/state/user_provider.dart

import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:num_1_test/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  static const _storageKey = 'user_accounts_v1';
  final List<User> _users = [];

  UnmodifiableListView<User> get users => UnmodifiableListView(_users);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final data = User.listFromJsonString(raw);
        _users
          ..clear()
          ..addAll(data);
      } catch (e) {
        if (kDebugMode) {
          print('UserProvider.load error: $e');
        }
      }
    }

    // Nếu không có tài khoản nào, tạo một tài khoản admin mặc định
    if (_users.isEmpty) {
      await add(User(username: 'admin', password: '123'), notify: false);
    }

    notifyListeners();
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, User.listToJsonString(_users));
    } catch (e) {
      if (kDebugMode) print('UserProvider persist error: $e');
    }
  }

  Future<bool> add(User user, {bool notify = true}) async {
    // Không cho phép trùng username
    if (_users.any((u) => u.username == user.username)) {
      return false;
    }
    _users.add(user);
    await _persist();
    if (notify) notifyListeners();
    return true;
  }

  Future<void> remove(String username) async {
    // Không cho phép xóa tài khoản cuối cùng
    if (_users.length <= 1) {
      return;
    }
    _users.removeWhere((u) => u.username == username);
    await _persist();
    notifyListeners();
  }

  bool validate(String username, String password) {
    try {
      final user = _users.firstWhere((u) => u.username == username);
      return user.password == password;
    } catch (e) {
      // Không tìm thấy user
      return false;
    }
  }
}