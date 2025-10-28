import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/room.dart';

List<Room> myRoomAtStart = [
  Room(
    id: '001',
    title: 'Living Room',
    imagePath: 'assets/images/living_room.png',
    deviceCount: 4,
  ),
  Room(
    id: '002',
    title: 'Bed Room',
    imagePath: 'assets/images/bed_room.png',
    deviceCount: 4,
  ),
  Room(
    id: '003',
    title: 'Kitchen',
    imagePath: 'assets/images/kitchen.png',
    deviceCount: 4,
  ),
];

class RoomProvider extends ChangeNotifier {
  static const _storageKey = 'rooms_v1';
  final List<Room> _rooms = [];

  UnmodifiableListView<Room> get rooms => UnmodifiableListView(_rooms);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final data = Room.listFromJsonString(raw);
        _rooms
          ..clear()
          ..addAll(data);
        notifyListeners();
      } catch (e) {
        if (kDebugMode) {
          print('RoomProvider.load error: $e');
        }
      }
    }

    // ----- test cho dễ hiểu => khi chạy thực tế thì comment lại -----
    if (_rooms.isEmpty) {
      // Nếu danh sách phòng trống -> nạp lại 3 phòng mặc định
      _rooms.addAll([
        Room(
          id: '001',
          title: 'Living Room',
          imagePath: 'assets/images/living_room.png',
          deviceCount: 4,
        ),
        Room(
          id: '002',
          title: 'Bed Room',
          imagePath: 'assets/images/bed_room.png',
          deviceCount: 4,
        ),
        Room(
          id: '003',
          title: 'Kitchen',
          imagePath: 'assets/images/kitchen.png',
          deviceCount: 4,
        ),
      ]);

      await _persistSafe(); // lưu lại mặc định
      notifyListeners();
    }
    // ----- comment lại -----
  }

  Future<void> add(Room room) async {
    // _rooms.add(room);
    // await _persist();
    // notifyListeners();
    _rooms.add(room);
    notifyListeners(); // cập nhật UI ngay nếu bỏ await đi
    _persistSafe(); // lưu nền, không chặn UI
  }

  Future<void> removeById(String id) async {
    _rooms.removeWhere((r) => r.id == id);
    // await _persist();
    notifyListeners();
    _persistSafe(); // lưu nền, không chặn UI
  }

  Future<void> update(Room room) async {
    final idx = _rooms.indexWhere((r) => r.id == room.id);
    if (idx != -1) {
      _rooms[idx] = room;
      // await _persist();
      notifyListeners();
      _persistSafe(); // lưu nền, không chặn UI
    }
  }

  Future<void> _persistSafe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, Room.listToJsonString(_rooms));
    } catch (e) {
      if (kDebugMode) print('RoomProvider persist error: $e');
    }
  }

  void clearRooms() {
    _rooms.clear(); // Xoá danh sách phòng trong RAM
    notifyListeners(); // Cập nhật lại UI
  }

  Future<void> resetToDefault() async {
    final prefs = await SharedPreferences.getInstance();

    final defaultRooms = [
      Room(
        id: '001',
        title: 'Living Room',
        imagePath: 'assets/images/living_room.png',
        deviceCount: 4,
      ),
      Room(
        id: '002',
        title: 'Bed Room',
        imagePath: 'assets/images/bed_room.png',
        deviceCount: 4,
      ),
      Room(
        id: '003',
        title: 'Kitchen',
        imagePath: 'assets/images/kitchen.png',
        deviceCount: 4,
      ),
    ];

    _rooms
      ..clear()
      ..addAll(defaultRooms);
    await prefs.setString(_storageKey, Room.listToJsonString(defaultRooms));

    notifyListeners();
  }

  // Hàm thêm mới để reset lại danh sách phòng mặc định
  // void addAll(List<Room> rooms) {
  //   _rooms
  //     ..clear()
  //     ..addAll(rooms);
  //   notifyListeners();
  // }
}
