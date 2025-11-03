// Chuẩn hoá topic MQTT (theo phòng)

class RoomTopics {
  static const String root = 'home';

  /// Thiết bị/edge → App: ảnh chụp trạng thái phòng (retained)
  static String snapshot(String roomId) => '$root/rooms/$roomId/snapshot';

  /// App → thiết bị/edge: lệnh điều khiển theo phòng
  static String command(String roomId) => '$root/rooms/$roomId/command';

  /// Subscribe tất cả snapshot của mọi phòng
  static String wildcardSnapshot() => '$root/rooms/+/snapshot';
}
