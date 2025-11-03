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
    final st = store.room(_roomId!);
    for (final d in _devices) {
      final id = _slug(d.name);
      if (st.deviceOn.containsKey(id)) {
        d.isOn = st.deviceOn[id] ?? d.isOn;
      }
    }
    notifyListeners();
  }

  void toggle(Device d) {
    if (_roomId == null) return;
    final id = _slug(d.name);
    final newVal = !d.isOn;
    d.isOn = newVal;

    // Publish + cập nhật store (MqttRoomStore sẽ lo publish MQTT)
    store.setDeviceOn(_roomId!, id, newVal);

    // Phản hồi tức thì trên UI
    notifyListeners();
  }

  @override
  void dispose() {
    store.removeListener(_storeListener);
    super.dispose();
  }
}
