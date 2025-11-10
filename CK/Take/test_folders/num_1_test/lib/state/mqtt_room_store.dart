// lib/state/mqtt_room_store.dart
// CHANGE: Subscribe thêm wildcardCommand và xử lý message /command (mirror)
// để khi bạn gửi lệnh từ Web Client, UI cũng đổi theo.

import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:num_1_test/mqtt/room_topics.dart';
import 'package:num_1_test/mqtt/room_payloads.dart';
import 'package:num_1_test/mqtt/mqtt_service.dart';

class RoomRuntimeState {
  final String roomId;
  final Map<String, bool> deviceOn; // deviceId -> on/off
  final Map<String, num> sensors; // sensorId -> value
  int ts;

  RoomRuntimeState({
    required this.roomId,
    Map<String, bool>? deviceOn,
    Map<String, num>? sensors,
    this.ts = 0,
  }) : deviceOn = deviceOn ?? <String, bool>{},
       sensors = sensors ?? <String, num>{};

  RoomRuntimeState copy() => RoomRuntimeState(
    roomId: roomId,
    deviceOn: Map<String, bool>.from(deviceOn),
    sensors: Map<String, num>.from(sensors),
    ts: ts,
  );
}

class MqttRoomStore extends ChangeNotifier {
  final MqttService _svc;

  final Map<String, RoomRuntimeState> _rooms = {};
  late final StreamSubscription _msgSub;
  late final StreamSubscription _connSub;

  UnmodifiableMapView<String, RoomRuntimeState> get rooms =>
      UnmodifiableMapView(_rooms);

  RoomRuntimeState room(String roomId) =>
      _rooms.putIfAbsent(roomId, () => RoomRuntimeState(roomId: roomId));

  MqttRoomStore({required MqttService service}) : _svc = service {
    // Lắng nghe message
    _msgSub = _svc.messages.listen(_onMessage);

    // Khi kết nối thành công thì (re)subscribe wildcard
    _connSub = _svc.connection.listen((ok) {
      if (ok) {
        _svc.subscribe(RoomTopics.wildcardSnapshot());
        _svc.subscribe(RoomTopics.wildcardCommand()); // CHANGE: mirror command
      }
    });
  }

  void _onMessage(MqttIncomingMessage m) {
    try {
      // SNAPSHOT: nguồn chân lý
      if (m.topic.endsWith('/snapshot')) {
        final pkt = RoomPacket.parse(m.payload);
        final cur = room(pkt.roomId).copy();
        for (final d in pkt.devices) {
          cur.deviceOn[d.id] = d.on;
        }
        for (final s in pkt.sensors) {
          cur.sensors[s.id] = s.value;
        }
        cur.ts = pkt.ts;
        _rooms[pkt.roomId] = cur;
        notifyListeners();
        return;
      }

      // CHANGE: COMMAND (mirror) — chỉ để tiện test khi chưa có edge
      if (m.topic.endsWith('/command')) {
        final cmd = RoomCommand.parse(m.payload);
        final cur = room(cmd.roomId).copy();
        for (final d in cmd.devices) {
          cur.deviceOn[d.id] = d.on;
        }
        // mark local time vì command không nhất thiết có ts dùng cho state
        cur.ts = DateTime.now().millisecondsSinceEpoch;
        _rooms[cmd.roomId] = cur;
        notifyListeners();
        return;
      }
    } catch (e) {
      debugPrint('[MqttRoomStore] parse error: $e');
    }
  }

  /// Thao tác bật/tắt 1 thiết bị trong 1 phòng.
  Future<void> setDevice(String roomId, String deviceId, bool on) async {
    final cmd = RoomCommand(
      roomId: roomId,
      devices: [DeviceStateDto(id: deviceId, on: on)],
    );
    await _svc.sendRoomCommand(cmd);

    // Cập nhật local ngay để UI phản hồi mượt
    final cur = room(roomId).copy();
    cur.deviceOn[deviceId] = on;
    cur.ts = DateTime.now().millisecondsSinceEpoch;
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
