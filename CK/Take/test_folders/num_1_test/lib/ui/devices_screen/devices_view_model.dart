import 'package:flutter/material.dart';
import 'package:num_1_test/ui/devices_screen/devices_model.dart';

class DevicesViewModel extends ChangeNotifier {
  // List các thiết bị tạo sẵn
  List<Device> device = [
    Device(
      name: 'Light Bulb 1',
      pathImageName: 'light_bulb',
      isOn: false,
      voltage: 220,
      current: 0.3,
      power: 17,
    ),
    Device(
      name: 'Fan',
      pathImageName: 'fan',
      isOn: false,
      voltage: 220,
      current: 0.15,
      power: 12,
    ),
    Device(
      name: 'Light Bulb 2',
      pathImageName: 'light_bulb',
      isOn: false,
      voltage: 220,
      current: 0.3,
      power: 17,
    ),
    Device(
      name: 'Freezer',
      pathImageName: 'freezer',
      isOn: false,
      voltage: 220,
      current: 1.6,
      power: 79.3,
    ),
  ];

  Device?
  selectedDevice; // lưu thiết bị đang được chọn, nếu chưa có trả về null

  // hàm chọn thiết bị
  void selectDevice(Device device) {
    selectedDevice = device;
    notifyListeners();
  }

  // Hàm bật tắt thiết bị
  void toggleDevice(Device device, bool value) {
    device.isOn = value;
    if (selectedDevice == device) {
      selectedDevice = device;
    }
    notifyListeners(); // UI liên quan sẽ cập nhật trạng thái mới.
  }
}
