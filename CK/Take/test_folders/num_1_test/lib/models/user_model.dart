// lib/models/user_model.dart

import 'dart:convert';

class User {
  final String username;
  final String password; // Lưu ý: Lưu plain text là không an toàn!

  User({required this.username, required this.password});

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    username: json['username'] as String,
    password: json['password'] as String,
  );

  static List<User> listFromJsonString(String source) {
    final list = jsonDecode(source) as List<dynamic>;
    return list.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String listToJsonString(List<User> users) {
    return jsonEncode(users.map((e) => e.toJson()).toList());
  }
}