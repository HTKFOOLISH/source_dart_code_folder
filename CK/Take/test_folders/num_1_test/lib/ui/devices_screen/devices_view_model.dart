import 'dart:collection';
import 'package:flutter/material.dart';
import 'devices_model.dart';
import '../../state/mqtt_room_store.dart';

/// Helper: tạo id ngắn từ tên thiết bị cũ (nếu UI chưa có deviceId)
String _slug(String name) {
  final s = name
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'(^-+|-+$)'), '');
  return s.isEmpty ? 'device' : s;
}

/// ViewModel bridge giữa store MQTT và UI device cũ
class DevicesViewModel extends ChangeNotifier {
  final MqttRoomStore store;

  final List<Device> _devices = [];
  UnmodifiableListView<Device> get devices => UnmodifiableListView(_devices);

  /// Alias để tương thích UI cũ: viewModel.device (List<Device>)
  List<Device> get device => _devices;
  set device(List<Device> value) {
    _devices
      ..clear()
      ..addAll(value);
    notifyListeners();
  }

  String? _roomId;

  // Đúng cho ChangeNotifier: add/remove listener dùng VoidCallback
  late final VoidCallback _storeListener;

  DevicesViewModel({required this.store}) {
    _storeListener = _onStoreChanged;
    store.addListener(_storeListener);
  }

  /// Gán phòng + danh sách thiết bị ban đầu từ UI cũ
  void bindRoom(String roomId, List<Device> initialUiDevices) {
    _roomId = roomId;

    // ✅ RẤT QUAN TRỌNG: tạo bản sao, tránh alias list
    final copy = List<Device>.from(initialUiDevices);

    _devices
      ..clear()
      ..addAll(initialUiDevices);

    _syncFromStore();
  }

  void _onStoreChanged() {
    if (_roomId == null) return;
    _syncFromStore();
  }

  void _syncFromStore() {
    final rid = _roomId;
    if (rid == null) return;

    final st = store.room(rid);
    bool changed = false;

    for (final d in _devices) {
      final id = _slug(d.name);
      if (st.deviceOn.containsKey(id)) {
        final v = st.deviceOn[id];
        if (v != null && v != d.isOn) {
          d.isOn = v;
          changed = true;
        }
      }
    }
    if (changed) notifyListeners();
  }

  /// API cũ có thể đã gọi: chuyển trạng thái bằng cách đảo
  void toggle(Device d) {
    // Cập nhật local trước để UI phản hồi ngay
    d.isOn = !d.isOn;
    notifyListeners();

    // Nếu đã bind phòng thì publish MQTT
    if (_roomId == null) return;
    final rid = _roomId!;
    final id = _slug(d.name);
    store.setDeviceOn(rid, id, d.isOn);
  }

  /// API mà UI hiện tại đang gọi trong living_room.dart:
  /// toggleDevice(device, value)
  void toggleDevice(Device d, bool value) {
    // Cập nhật local trước để UI phản hồi ngay
    d.isOn = value;
    notifyListeners();

    // Nếu đã bind phòng thì publish MQTT
    if (_roomId == null) return;
    final rid = _roomId!;
    final id = _slug(d.name);
    store.setDeviceOn(rid, id, value);
  }

  @override
  void dispose() {
    store.removeListener(_storeListener);
    super.dispose();
  }
}
