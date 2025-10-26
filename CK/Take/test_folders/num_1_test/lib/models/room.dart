
import 'dart:convert';

class Room {
  final String id;
  final String title;
  final String imagePath;
  final int deviceCount;
  final bool initialState;

  const Room({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.deviceCount,
    this.initialState = false,
  });

  Room copyWith({
    String? id,
    String? title,
    String? imagePath,
    int? deviceCount,
    bool? initialState,
  }) {
    return Room(
      id: id ?? this.id,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      deviceCount: deviceCount ?? this.deviceCount,
      initialState: initialState ?? this.initialState,
    );
  }

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json['id'] as String,
        title: json['title'] as String,
        imagePath: json['imagePath'] as String,
        deviceCount: json['deviceCount'] as int,
        initialState: json['initialState'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'imagePath': imagePath,
        'deviceCount': deviceCount,
        'initialState': initialState,
      };

  static List<Room> listFromJsonString(String source) {
    final list = jsonDecode(source) as List<dynamic>;
    return list.map((e) => Room.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String listToJsonString(List<Room> rooms) {
    return jsonEncode(rooms.map((e) => e.toJson()).toList());
  }
}
