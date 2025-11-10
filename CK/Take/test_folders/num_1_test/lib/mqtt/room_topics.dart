// lib/mqtt/room_topics.dart
// CHANGE: Giữ nguyên cấu trúc topic nhưng gom vào 1 class tĩnh rõ ràng.

class RoomTopics {
  static const String root = 'home'; // mặc định, có thể đổi nếu cần

  /// Thiết bị/edge → App: trạng thái phòng (retained)
  static String snapshot(String roomId) => '$root/rooms/$roomId/snapshot';

  /// App → thiết bị/edge: lệnh điều khiển theo phòng
  static String command(String roomId) => '$root/rooms/$roomId/command';

  /// Subscribe tất cả snapshot của mọi phòng
  static String wildcardSnapshot() => '$root/rooms/+/snapshot';

  /// CHANGE: Subscribe tất cả command của mọi phòng (mirror mode)
  static String wildcardCommand() => '$root/rooms/+/command';
}
