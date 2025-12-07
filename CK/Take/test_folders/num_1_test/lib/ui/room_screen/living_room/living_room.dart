// living_room.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:num_1_test/state/mqtt_room_store.dart';
import 'package:num_1_test/ui/widgets/show_icon_options.dart';
import 'package:provider/provider.dart';
import 'package:num_1_test/models/room.dart';
import 'package:num_1_test/ui/devices_screen/devices_view_model.dart';
import 'package:num_1_test/ui/devices_screen/devices_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Helper: tạo id ngắn từ tên thiết bị (giống bên devices_view_model.dart)
String _slug(String name) {
  final s = name
      .toLowerCase()
      .replaceAll(
        RegExp(r'[^a-z0-9]+'),
        '-',
      ) // thay khoảng trắng, ký tự lạ bằng '-'
      .replaceAll(RegExp(r'(^-+|-+$)'), ''); // bỏ '-' ở đầu/cuối
  return s.isEmpty ? 'device' : s;
}

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
    return ChangeNotifierProvider<DevicesViewModel>(
      create: (ctx) => DevicesViewModel(store: ctx.read<MqttRoomStore>()),
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
            LivingRoomBodyScreen(roomId: room.id, roomName: room.title),

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
  final String roomName;
  const LivingRoomBodyScreen({
    super.key,
    required this.roomId,
    required this.roomName,
  });

  @override
  State<StatefulWidget> createState() => _LivingRoomBodyScreenState();
}

class _LivingRoomBodyScreenState extends State<LivingRoomBodyScreen> {
  bool isOnTap = false;
  int count = 0;

  // Trả về 4 thiết bị mặc định tùy loại phòng.
  // Đổi pathImageName theo assets bạn đang có (png + _on.gif).
  String _roomTypeFromName(String roomName) {
    final s = roomName.toLowerCase();

    // Bedroom
    if (s.contains('bed') || s.contains('ngủ') || s.contains('phòng ngủ')) {
      return 'bedroom';
    }

    // Kitchen
    if (s.contains('kitchen') || s.contains('bếp')) {
      return 'kitchen';
    }

    // Living room / Phòng khách
    if (s.contains('living') ||
        s.contains('khách') ||
        s.contains('phòng khách')) {
      return 'living';
    }

    // Reading room / Thư viện
    if (s.contains('read') || s.contains('đọc') || s.contains('thư viện'))
      return 'reading';

    // Không khớp từ khoá nào → dùng "generic"
    return 'generic';
  }

  List<Device> _defaultDevicesForRoom(String roomName) {
    final type = _roomTypeFromName(roomName);

    switch (type) {
      case 'bedroom':
        return [
          Device(
            name: 'Bed Lamp',
            pathImageName: 'light_bulb',
            isOn: false,
            voltage: 220,
            current: 0.0,
            power: 0.0,
          ),
          Device(
            name: 'Ceiling Light',
            pathImageName: 'light_bulb',
            isOn: false,
            voltage: 220,
            current: 0.0,
            power: 0.0,
          ),
          Device(
            name: 'Fan',
            pathImageName: 'fan',
            isOn: false,
            voltage: 220,
            current: 0.0,
            power: 0.0,
          ),
          Device(
            name: 'Air Conditioner',
            pathImageName: 'freezer',
            isOn: false,
            voltage: 220,
            current: 0.0,
            power: 0.0,
          ),
        ];

      case 'kitchen':
        return [
          Device(
            name: 'Kitchen Ceiling Light',
            pathImageName: 'light_bulb',
            isOn: false,
            voltage: 220,
            current: 0.0,
            power: 0.0,
          ),
          Device(
            name: 'Cabinet Lighting',
            pathImageName: 'light_bulb',
            isOn: false,
            voltage: 220,
            current: 0.0,
            power: 0.0,
          ),
          Device(
            name: 'Kitchen Hood', // máy hút mùi
            pathImageName: 'freezer',
            isOn: false,
            voltage: 220,
            current: 0.0,
            power: 0.0,
          ),
          Device(
            name: 'Kitchen Fan',
            pathImageName: 'fan',
            isOn: false,
            voltage: 220,
            current: 0.0,
            power: 0.0,
          ),
        ];

      case 'reading':
        return [
          Device(
            name: 'Mirror Light',
            pathImageName: 'light_bulb',
            isOn: false,
            voltage: 220,
            current: 0.0,
            power: 0.0,
          ),
          Device(
            name: 'Ceiling Light',
            pathImageName: 'light_bulb',
            isOn: false,
            voltage: 220,
            current: 0.0,
            power: 0.0,
          ),
          Device(
            name: 'Water Heater',
            pathImageName: 'freezer',
            isOn: false,
            voltage: 220,
            current: 0.0,
            power: 0.0,
          ),
          Device(
            name: 'Exhaust Fan',
            pathImageName: 'fan',
            isOn: false,
            voltage: 220,
            current: 0.0,
            power: 0.0,
          ),
        ];

      case 'living':
        return [
          Device(
            name: 'Ceiling Light',
            pathImageName: 'light_bulb',
            isOn: false,
            voltage: 220,
            current: 0.0,
            power: 0.0,
          ),
          Device(
            name: 'Fan',
            pathImageName: 'fan',
            isOn: false,
            voltage: 220,
            current: 0.0,
            power: 0.0,
          ),
          Device(
            name: 'Air Conditioner',
            pathImageName: 'freezer',
            isOn: false,
            voltage: 220,
            current: 0.0,
            power: 0.0,
          ),
          Device(
            name: 'Floor Lamp',
            pathImageName: 'light_bulb',
            isOn: false,
            voltage: 220,
            current: 0.0,
            power: 0.0,
          ),
        ];

      default: // 'generic' + mọi tên phòng tùy ý như "abcxyz"
        return [
          Device(
            name: 'Ceiling Light',
            pathImageName: 'light_bulb',
            isOn: false,
            voltage: 220,
            current: 0.0,
            power: 0.0,
          ),
          Device(
            name: 'Fan',
            pathImageName: 'fan',
            isOn: false,
            voltage: 220,
            current: 0.0,
            power: 0.0,
          ),
          Device(
            name: 'Table Lamp',
            pathImageName: 'light_bulb',
            isOn: false,
            voltage: 220,
            current: 0.0,
            power: 0.0,
          ),
          Device(
            name: 'Air Conditioner',
            pathImageName: 'freezer',
            isOn: false,
            voltage: 220,
            current: 0.0,
            power: 0.0,
          ),
        ];
    }
  }

  @override
  void initState() {
    super.initState();
    // Gọi sau frame đầu tiên để chắc chắn Provider sẵn sàng
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // DEBUG clear once:
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.remove(_storageKey());
      _loadDevices();
    });
  }

  String _storageKey() {
    // nếu roomId có giá trị → dùng roomId
    final id = widget.roomId.trim();
    if (id.isNotEmpty) return 'devices_$id';

    // nếu roomId rỗng, dùng slug từ roomName
    final slug = widget.roomName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return 'devices_${slug.isEmpty ? 'room' : slug}';
  }

  Future<void> _loadDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _storageKey();
    final viewModel = Provider.of<DevicesViewModel>(context, listen: false);

    print('[devices] storageKey = $key'); // <— log

    List<Device>? devices;

    // Đọc dữ liệu đã lưu (nếu có) — robust
    try {
      final jsonData = prefs.getString(key);
      print(
        '[devices] raw json = ${jsonData?.substring(0, (jsonData.length > 100 ? 100 : jsonData.length))}',
      ); // <— log
      if (jsonData != null && jsonData.trim().isNotEmpty) {
        final decoded = jsonDecode(jsonData);
        if (decoded is List) {
          devices = decoded
              .whereType<Map<String, dynamic>>()
              .map((e) => Device.fromJson(e))
              .toList();
          print('[devices] loaded ${devices.length} items'); // <— log
        } else {
          print('[devices] data is not a List; will seed defaults');
        }
      }
    } catch (e) {
      print('[devices] parse error: $e — will seed defaults');
    }

    // Nếu chưa có hoặc rỗng → seed theo tên phòng
    if (devices == null || devices.isEmpty) {
      final defaults = _defaultDevicesForRoom(widget.roomName);
      devices = defaults;
      await _saveDevices(defaults);
      print('[devices] seeded ${defaults.length} items for ${widget.roomName}');
    }

    if (!mounted) return;

    // Gán vào ViewModel (setter đã notifyListeners)
    viewModel.device = devices;

    // Bind room để bật/tắt hoạt động qua MQTT về sau
    viewModel.bindRoom(widget.roomId, List<Device>.from(viewModel.device));

    print('[devices] viewModel set + bindRoom done'); // <— log

    // Lấy store
    final store = Provider.of<MqttRoomStore>(context, listen: false);

    // 1) Load sensors đã lưu (nếu có) cho room này
    await store.loadSensorsFromPrefs(widget.roomId);

    // 2) Sau khi load xong, lấy runtimeState hiện tại
    final runtimeState = store.room(widget.roomId);

    // 3) CHỈ seed sensor nếu hiện tại *chưa có* sensor nào trong store
    if (runtimeState.sensors.isEmpty) {
      // build trạng thái device cho store (id: slug(name))
      final deviceStates = <String, bool>{};
      for (final d in devices) {
        final id = _slug(d.name);
        deviceStates[id] = d.isOn;
      }

      // Hardcode sensor giả + publish snapshot lên MQTT
      final fakeSensors = <String, num>{'temp': 26.5, 'hum': 58};

      await store.setSensorsAndPublish(
        widget.roomId,
        deviceStates,
        fakeSensors,
      );

      print(
        '[sensors] seeded fake sensors for room ${widget.roomId} (first time only)',
      );
    } else {
      // 4) ĐÃ có sensor (từ prefs hoặc từ MQTT) -> publish lại snapshot hiện tại
      await store.publishCurrentSnapshot(widget.roomId);
      print(
        '[sensors] room ${widget.roomId} already has sensors, republish current snapshot',
      );
    }
  }

  Future<void> _saveDevices(List<Device> devices) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _storageKey(); // dùng cùng key
    final encoded = jsonEncode(devices.map((d) => d.toJson()).toList());
    await prefs.setString(key, encoded);
  }

  @override
  Widget build(BuildContext context) {
    // ÉP theo dõi DevicesViewModel ở level toàn bộ body
    final vm = context.watch<DevicesViewModel>();
    // DEBUG (tạm thời): in độ dài list mỗi lần rebuild
    // ignore: avoid_print
    print('[devices] build list length = ${vm.device.length}');
    return Column(
      children: [
        // Hiển thị thông số cho từng thiết bị khi bấm vào
        DeviceInfo(indexCounter: count),

        // ##### PHẦN THÊM MỚI (SENSOR) #####
        // ***** SENSOR: đọc từ MqttRoomStore *****
        Consumer<MqttRoomStore>(
          builder: (context, store, _) {
            final state = store.room(widget.roomId);

            final num? temp = state.sensors['temp'];
            final num? hum = state.sensors['hum'];

            final tempText = temp != null
                ? '${temp.toStringAsFixed(1)} °C'
                : '--';
            final humText = hum != null ? '${hum.toStringAsFixed(0)} %' : '--';

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _SensorCard(
                      icon: Icons.thermostat,
                      label: 'Temperature',
                      value: tempText,
                      iconColor: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SensorCard(
                      icon: Icons.water_drop_outlined,
                      label: 'Humidity',
                      value: humText,
                      iconColor: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        // ***** HẾT SENSOR *****
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
          child: Builder(
            builder: (context) {
              if (vm.device.isEmpty) {
                return Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final newList = [
                        ...vm.device,
                        Device(
                          name: 'New Device',
                          pathImageName: 'unknown',
                          isOn: false,
                          voltage: 220,
                          current: 0.0,
                          power: 0.0,
                        ),
                      ];
                      vm.device = newList; // dùng setter để notify
                      await _saveDevices(newList); // lưu lại ngay
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Thêm thiết bị mới'),
                  ),
                );
              }

              return ListView.builder(
                itemCount: vm.device.length,
                itemBuilder: (context, index) {
                  final device = vm.device[index];
                  return InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    onTap: () {
                      setState(() {
                        count = index;
                        isOnTap = true;
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
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
                            style: const TextStyle(fontSize: 20),
                          ), // giữ nguyên style cũ nếu bạn cần
                        ),
                        trailing: Switch(
                          value: device.isOn,
                          onChanged: (value) async {
                            vm.toggleDevice(device, value);
                            await _saveDevices(vm.device);
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
