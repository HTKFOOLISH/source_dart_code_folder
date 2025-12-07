// lib/mqtt/room_payloads.dart
// CHANGE: Thêm parse cho RoomCommand để có thể đọc command từ broker.

import 'dart:convert';

class DeviceStateDto {
  final String id; // ex: "light-1"
  final bool on;
  const DeviceStateDto({required this.id, required this.on});

  factory DeviceStateDto.fromJson(Map<String, dynamic> j) =>
      DeviceStateDto(id: j['id'] as String, on: j['on'] == true);

  Map<String, dynamic> toJson() => {'id': id, 'on': on};
}

class SensorDto {
  final String id; // ex: "temp" | "hum"
  final num value;
  const SensorDto({required this.id, required this.value});

  factory SensorDto.fromJson(Map<String, dynamic> j) =>
      SensorDto(id: j['id'] as String, value: j['value'] as num);

  Map<String, dynamic> toJson() => {'id': id, 'value': value};
}

/// Snapshot toàn phòng gửi từ edge → app
class RoomPacket {
  final String roomId;
  final List<DeviceStateDto> devices;
  final List<SensorDto> sensors;
  final int ts;

  const RoomPacket({
    required this.roomId,
    required this.devices,
    required this.sensors,
    required this.ts,
  });

  factory RoomPacket.fromJson(Map<String, dynamic> j) => RoomPacket(
    roomId: j['roomId'] as String,
    devices: (j['devices'] as List<dynamic>? ?? [])
        .map((e) => DeviceStateDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    sensors: (j['sensors'] as List<dynamic>? ?? [])
        .map((e) => SensorDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    ts: (j['ts'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
  );

  Map<String, dynamic> toJson() => {
    'roomId': roomId,
    'devices': devices.map((e) => e.toJson()).toList(),
    'sensors': sensors.map((e) => e.toJson()).toList(),
    'ts': ts,
  };

  static RoomPacket parse(String s) =>
      RoomPacket.fromJson(jsonDecode(s) as Map<String, dynamic>);

  String encode() => jsonEncode(toJson());

  num? sensorValue(String id) {
    final f = sensors.where((s) => s.id == id).toList();
    return f.isEmpty ? null : f.first.value;
  }
}

/// Lệnh điều khiển app → edge
class RoomCommand {
  final String roomId;
  final List<DeviceStateDto> devices;

  const RoomCommand({required this.roomId, required this.devices});

  Map<String, dynamic> toJson() => {
    'roomId': roomId,
    'devices': devices.map((e) => e.toJson()).toList(),
    'ts': DateTime.now().millisecondsSinceEpoch,
  };

  String encode() => jsonEncode(toJson());

  // CHANGE: thêm parser để mirror command từ broker
  factory RoomCommand.fromJson(Map<String, dynamic> j) => RoomCommand(
    roomId: j['roomId'] as String,
    devices: (j['devices'] as List<dynamic>? ?? [])
        .map((e) => DeviceStateDto.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  // CHANGE: parse từ chuỗi JSON
  static RoomCommand parse(String s) =>
      RoomCommand.fromJson(jsonDecode(s) as Map<String, dynamic>);
}
