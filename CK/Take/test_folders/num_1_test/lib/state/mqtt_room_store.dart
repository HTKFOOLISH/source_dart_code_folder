// lib/state/mqtt_room_store.dart
// CHANGE: Subscribe thêm wildcardCommand và xử lý message /command (mirror)
// để khi bạn gửi lệnh từ Web Client, UI cũng đổi theo.

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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

  // ====== PERSIST SENSORS TO SHARED PREFERENCES ======

  static String _sensorsPrefKey(String roomId) => 'room_sensors_$roomId';

  Future<void> _saveSensorsToPrefs(String roomId) async {
    final prefs = await SharedPreferences.getInstance();
    final state = room(roomId);
    final map = <String, num>{};
    state.sensors.forEach((k, v) => map[k] = v);
    final jsonStr = jsonEncode(map);
    await prefs.setString(_sensorsPrefKey(roomId), jsonStr);
  }

  Future<void> loadSensorsFromPrefs(String roomId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_sensorsPrefKey(roomId));
    if (jsonStr == null || jsonStr.trim().isEmpty) return;

    try {
      final decoded = jsonDecode(jsonStr);
      if (decoded is Map<String, dynamic>) {
        final cur = room(roomId).copy();
        decoded.forEach((key, value) {
          if (value is num) {
            cur.sensors[key] = value;
          }
        });
        _rooms[roomId] = cur;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('[MqttRoomStore] loadSensorsFromPrefs error: $e');
    }
  }

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
        // _svc.subscribe(RoomTopics.wildcardSnapshot());
        // _svc.subscribe(RoomTopics.wildcardCommand()); // CHANGE: mirror command
        _subscribeAll();
      }
    });

    // 🔥 FIX: nếu tại thời điểm tạo store mà MQTT đã kết nối rồi thì subscribe luôn
    if (_svc.isConnected) {
      _subscribeAll();
    }
  }

  void _subscribeAll() {
    _svc.subscribe(RoomTopics.wildcardSnapshot());
    _svc.subscribe(RoomTopics.wildcardCommand());
  }

  void _onMessage(MqttIncomingMessage m) {
    try {
      // SNAPSHOT: chỉ dùng để sync sensor (KHÔNG đụng tới deviceOn)
      if (m.topic.endsWith('/snapshot')) {
        final pkt = RoomPacket.parse(m.payload);
        final cur = room(pkt.roomId).copy();

        // KHÔNG ghi đè trạng thái device ở đây nữa
        // for (final d in pkt.devices) {
        //   cur.deviceOn[d.id] = d.on;
        // }

        // Sensor: luôn lấy giá trị mới nhất từ snapshot
        for (final s in pkt.sensors) {
          cur.sensors[s.id] = s.value;
        }

        cur.ts = pkt.ts;
        _rooms[pkt.roomId] = cur;
        notifyListeners();

        // Lưu sensors mới nhất xuống SharedPreferences
        // ignore: unawaited_futures
        _saveSensorsToPrefs(pkt.roomId);

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

  /// Set (hoặc cập nhật) toàn bộ sensors cho 1 phòng và publish snapshot lên MQTT.
  /// Set (hoặc cập nhật) toàn bộ sensors cho 1 phòng và publish snapshot lên MQTT.
  Future<void> setSensorsAndPublish(
    String roomId,
    Map<String, bool> devicesOn,
    Map<String, num> sensors,
  ) async {
    // 1) Cập nhật local store
    final cur = room(roomId).copy();

    // Ghi đè toàn bộ state thiết bị
    cur.deviceOn
      ..clear()
      ..addAll(devicesOn);

    // Ghi đè toàn bộ state sensor
    cur.sensors
      ..clear()
      ..addAll(sensors);

    cur.ts = DateTime.now().millisecondsSinceEpoch;
    _rooms[roomId] = cur;
    notifyListeners();

    // 1b) Lưu sensors xuống SharedPreferences
    await _saveSensorsToPrefs(roomId);

    // 2) Build RoomPacket từ state hiện tại (devices + sensors)
    final pkt = RoomPacket(
      roomId: roomId,
      devices: cur.deviceOn.entries
          .map((e) => DeviceStateDto(id: e.key, on: e.value))
          .toList(),
      sensors: cur.sensors.entries
          .map((e) => SensorDto(id: e.key, value: e.value))
          .toList(),
      ts: cur.ts,
    );

    // 3) Publish snapshot lên broker
    await _svc.sendRoomSnapshot(pkt);
  }

  /// Publish lại snapshot hiện tại của 1 room (không thay đổi state).
  Future<void> publishCurrentSnapshot(String roomId) async {
    final cur = room(roomId); // dùng state hiện tại

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

    await _svc.sendRoomSnapshot(pkt);
  }

  @override
  void dispose() {
    _msgSub.cancel();
    _connSub.cancel();
    super.dispose();
  }
}
