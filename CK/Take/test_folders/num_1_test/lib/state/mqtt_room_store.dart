// Store runtime theo phòng (để UI cập nhật tự động)
import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../mqtt/room_topics.dart';
import '../mqtt/room_payloads.dart';
import '../mqtt/mqtt_service.dart';

class RoomRuntimeState {
  final String roomId;
  final Map<String, bool> deviceOn; // deviceId -> on/off
  final Map<String, num> sensors; // sensorId -> value
  int ts;

  RoomRuntimeState({
    required this.roomId,
    Map<String, bool>? deviceOn,
    Map<String, num>? sensors,
    int? ts,
  }) : deviceOn = Map.of(deviceOn ?? const {}),
       sensors = Map.of(sensors ?? const {}),
       ts = ts ?? DateTime.now().millisecondsSinceEpoch;

  RoomRuntimeState copyWith({
    Map<String, bool>? deviceOn,
    Map<String, num>? sensors,
    int? ts,
  }) {
    return RoomRuntimeState(
      roomId: roomId,
      deviceOn: deviceOn ?? this.deviceOn,
      sensors: sensors ?? this.sensors,
      ts: ts ?? this.ts,
    );
  }

  void applyPacket(RoomPacket p) {
    if (p.roomId != roomId) return;
    deviceOn
      ..clear()
      ..addEntries(p.devices.map((d) => MapEntry(d.id, d.on)));
    sensors
      ..clear()
      ..addEntries(p.sensors.map((s) => MapEntry(s.id, s.value)));
    ts = p.ts;
  }
}

class MqttRoomStore extends ChangeNotifier {
  /// Luôn dùng cùng một MqttService (truyền từ ngoài hoặc fallback singleton)
  final MqttService _svc; // thêm field

  final Map<String, RoomRuntimeState> _rooms = {};
  late final StreamSubscription _msgSub;
  late final StreamSubscription _connSub;

  UnmodifiableMapView<String, RoomRuntimeState> get rooms =>
      UnmodifiableMapView(_rooms);

  RoomRuntimeState room(String roomId) =>
      _rooms.putIfAbsent(roomId, () => RoomRuntimeState(roomId: roomId));

  /// ✅ Chỉ một constructor. Nhận `service` tuỳ chọn để tránh double-connect.
  /// Không tự connect ở đây; connect được gọi ở `main.dart` trước đó.
  MqttRoomStore({MqttService? service}) : _svc = service ?? MqttService.I {
    // DEBUG
    // ignore: avoid_print
    print('[MqttRoomStore] instance = ${identityHashCode(this)}');

    // Lắng nghe message từ service
    _msgSub = _svc.messages.listen(_onMessage);

    // Khi kết nối thành công, subscribe wildcard 1 lần
    _connSub = _svc.connection.listen((connected) {
      if (connected) {
        // Subscribe wildcard snapshot
        _svc.subscribe(RoomTopics.wildcardSnapshot());
      }
    });
  }

  void _onMessage(MqttIncomingMessage m) {
    // Chỉ xử lý các topic snapshot (ví dụ: rooms/<roomId>/snapshot)
    // final snapPrefix = 'rooms/';
    if (!m.topic.contains('/snapshot')) return;

    try {
      final pkt = RoomPacket.parse(m.payload);
      final st = room(pkt.roomId);
      st.applyPacket(pkt);
      _rooms[pkt.roomId] = st;
      notifyListeners();
    } catch (e) {
      // ignore lỗi parse
      print('LỖI PARSE RoomPacket TỪ MQTT: $e');
    }
  }

  /// App muốn bật/tắt 1 device trong phòng
  void setDeviceOn(String roomId, String deviceId, bool on) {
    final cur = room(roomId);
    cur.deviceOn[deviceId] = on;

    // Gửi lệnh command (giữ nguyên các thiết bị khác ở trạng thái hiện tại)
    final pkt = RoomPacket(
      roomId: roomId,
      devices: cur.deviceOn.entries
          .map((e) => DeviceStateDto(id: e.key, on: e.value))
          .toList(),
      sensors: cur.sensors.entries
          .map((e) => SensorDto(id: e.key, value: e.value))
          .toList(),
      ts: DateTime.now().millisecondsSinceEpoch,
    );

    // ✅ Dùng đúng instance _svc (không gọi trực tiếp singleton)
    _svc.publishString(RoomTopics.command(roomId), pkt.encode());

    // Cập nhật local ngay để UI phản hồi mượt
    _rooms[roomId] = cur;
    notifyListeners();
  }

  @override
  void dispose() {
    _msgSub.cancel();
    _connSub.cancel();
    super.dispose();
  }
}
