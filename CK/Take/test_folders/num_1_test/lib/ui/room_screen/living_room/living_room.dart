// living_room.dart

import 'dart:convert';
import 'dart:async'; // <-- THÊM VÀO
import 'dart:math'; // <-- THÊM VÀO

import 'package:flutter/material.dart';
import 'package:num_1_test/ui/widgets/show_icon_options.dart';
import 'package:provider/provider.dart';
import 'package:num_1_test/models/room.dart';
import 'package:num_1_test/ui/devices_screen/devices_view_model.dart';
import 'package:num_1_test/ui/devices_screen/devices_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LivingRoomRoomArgs extends StatelessWidget {
  const LivingRoomRoomArgs({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Room) {
      return LivingRoom(room: args);
    } else {
      return const Scaffold(
        body: Center(child: Text('Không có dữ liệu phòng được truyền vào.')),
      );
    }
  }
}

class LivingRoom extends StatefulWidget {
  final Room room;
  const LivingRoom({super.key, required this.room});

  @override
  State<StatefulWidget> createState() => LivingRoomState();
}

class LivingRoomState extends State<LivingRoom>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Room room; // Nhận dữ liệu phòng

  bool isToggle = false;
  bool isShowIconMenu = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    room = widget.room;
  }

  void _toggleMenu() {
    setState(() {
      isToggle = !isToggle;
      isShowIconMenu = !isShowIconMenu;
      isToggle ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DevicesViewModel(store: ),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/IoT_logo.png', height: 55),
              Text(room.title.isNotEmpty ? room.title : 'Loading...'),
              IconButton(
                onPressed: _toggleMenu,
                icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  progress: _controller,
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            LivingRoomBodyScreen(roomId: room.id),

            // Ẩn/Hiện menu trên thanh AppBar
            if (isShowIconMenu) ShowIconOptions(isShowMenu: true),
          ],
        ),
      ),
    );
  }
}

class LivingRoomBodyScreen extends StatefulWidget {
  final String roomId;
  const LivingRoomBodyScreen({super.key, required this.roomId});

  @override
  State<StatefulWidget> createState() => _LivingRoomBodyScreenState();
}

class _LivingRoomBodyScreenState extends State<LivingRoomBodyScreen> {
  bool isOnTap = false;
  int count = 0;

  // ##### PHẦN THÊM MỚI (SENSOR) #####
  double _temperature = 25.0;
  int _humidity = 60;
  final Random _random = Random();
  Timer? _sensorTimer;
  // ##### KẾT THÚC PHẦN THÊM MỚI #####

  @override
  void initState() {
    super.initState();
    _loadDevices(); // Khi vào trang thì load trạng thái đã lưu

    // ##### PHẦN THÊM MỚI (SENSOR) #####
    // Khởi tạo giá trị ban đầu
    _generateSensorData();
    // Bắt đầu timer cập nhật sensor mỗi 3 giây
    _sensorTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _generateSensorData();
    });
    // ##### KẾT THÚC PHẦN THÊM MỚI #####
  }

  // ##### PHẦN THÊM MỚI (SENSOR) #####
  @override
  void dispose() {
    _sensorTimer?.cancel(); // Huỷ timer khi widget bị huỷ
    super.dispose();
  }

  void _generateSensorData() {
    if (!mounted) return; // Kiểm tra nếu widget còn tồn tại
    setState(() {
      // Tạo dao động nhỏ quanh giá trị hiện tại
      _temperature += _random.nextDouble() * 0.4 - 0.2; // +/- 0.2
      _temperature = _temperature.clamp(20.0, 35.0); // Giữ trong khoảng 20-35

      _humidity += _random.nextInt(5) - 2; // +/- 2
      _humidity = _humidity.clamp(40, 80); // Giữ trong khoảng 40-80
    });
  }
  // ##### KẾT THÚC PHẦN THÊM MỚI #####

  Future<void> _loadDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString('devices_${widget.roomId}');
    if (jsonData != null && mounted) {
      // Thêm kiểm tra 'mounted'
      final decoded = jsonDecode(jsonData) as List;
      final devices = decoded
          .map((e) => Device.fromJson(e as Map<String, dynamic>))
          .toList();
      final viewModel = Provider.of<DevicesViewModel>(context, listen: false);
      viewModel.device = devices;
      viewModel.notifyListeners();
    }
  }

  Future<void> _saveDevices(List<Device> devices) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(devices.map((d) => d.toJson()).toList());
    await prefs.setString('devices_${widget.roomId}', encoded);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hiển thị thông số cho từng thiết bị khi bấm vào
        DeviceInfo(indexCounter: count),

        // ##### PHẦN THÊM MỚI (SENSOR) #####
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: _SensorCard(
                  icon: Icons.thermostat,
                  label: 'Temperature',
                  value:
                      '${_temperature.toStringAsFixed(1)} °C', // Format 1 chữ số thập phân
                  iconColor: Colors.redAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SensorCard(
                  icon: Icons.water_drop_outlined,
                  label: 'Humidity',
                  value: '$_humidity %',
                  iconColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),

        // ##### KẾT THÚC PHẦN THÊM MỚI #####
        Padding(
          padding: const EdgeInsets.fromLTRB(
            20.0,
            12.0,
            20.0,
            12.0,
          ), // Giảm padding top
          child: Row(children: [const Text('Running Devices')]),
        ),

        // Thẻ các thiết bị
        Expanded(
          flex: 3,
          child: Consumer<DevicesViewModel>(
            builder: (context, viewModel, _) {
              // Kiểm tra nếu ban đầu chưa có thiết bị nào
              if (viewModel.device.isEmpty) {
                return Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      viewModel.device.add(
                        Device(
                          name: 'New Device',
                          pathImageName: 'default_device', // Cần có ảnh này
                          isOn: false,
                          voltage: 220,
                          current: 0.0,
                          power: 0.0,
                        ),
                      );
                      viewModel.notifyListeners();
                      await _saveDevices(viewModel.device); // Lưu sau khi thêm
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Thêm thiết bị mới'),
                  ),
                );
              }

              // Nếu có thiết bị, hiển thị ListView
              return ListView.builder(
                itemCount: viewModel.device.length,
                itemBuilder: (context, index) {
                  final device = viewModel.device[index];
                  return InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    onTap: () {
                      setState(() {
                        count = index;
                        isOnTap = true;
                      });
                    },

                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        side: BorderSide(
                          color: (count == index)
                              ? Colors.blue
                              : Colors.white60,
                          width: (count == index) ? 5 : 3,
                        ),
                      ),
                      child: ListTile(
                        leading: Image.asset(
                          'assets/images/${device.pathImageName}.png',
                          scale: .5,
                        ),
                        title: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Text(
                            device.name,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        trailing: Switch(
                          value: device.isOn,
                          onChanged: (value) async {
                            Provider.of<DevicesViewModel>(
                              context,
                              listen: false,
                            ).toggleDevice(device, value);
                            await _saveDevices(
                              viewModel.device,
                            ); // Lưu lại khi bật/tắt
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class DeviceInfo extends StatefulWidget {
  final int indexCounter;
  const DeviceInfo({super.key, required this.indexCounter});

  @override
  State<DeviceInfo> createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  int get _count => widget.indexCounter;

  @override
  Widget build(BuildContext context) {
    // Sử dụng Consumer thay vì Provider.of để xử lý trường hợp list rỗng
    return Consumer<DevicesViewModel>(
      builder: (context, viewModel, child) {
        // Nếu viewModel chưa có thiết bị nào (hoặc đang tải)
        if (viewModel.device.isEmpty) {
          return Expanded(
            flex: 2,
            child: Center(
              child: Text(
                'Chưa có thiết bị nào trong phòng.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          );
        }

        // Đảm bảo _count không vượt quá index
        final int validCount = _count.clamp(0, viewModel.device.length - 1);
        final device = viewModel.device[validCount];

        String icon = (device.isOn)
            ? "${device.pathImageName}_on.gif"
            : "${device.pathImageName}.png";

        return Expanded(
          flex: 2,
          child: Column(
            children: [
              Expanded(flex: 2, child: Image.asset('assets/images/$icon')),
              Expanded(
                child: Text(
                  "${device.name} is ${(device.isOn) ? 'Turn On' : 'Turn Off'}",
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(child: Text('Current: ${device.current}')),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(child: Text('Voltage: ${device.voltage}')),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(child: Text('Power: ${device.power}')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ##### WIDGET MỚI CHO SENSOR #####
class _SensorCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _SensorCard({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.white60, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Giảm padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 36), // Giảm kích thước icon
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 16, color: Colors.white70)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20, // Giảm kích thước chữ
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
