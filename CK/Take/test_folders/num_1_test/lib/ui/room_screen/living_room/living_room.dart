import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:num_1_test/ui/home_screen/home_screen.dart';
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
      create: (_) => DevicesViewModel(),
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
            if (isShowIconMenu) const ShowIconOptions(isShowMenu: true),
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

  @override
  void initState() {
    super.initState();
    _loadDevices(); // Khi vào trang thì load trạng thái đã lưu
  }

  Future<void> _loadDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString('devices_${widget.roomId}');
    if (jsonData != null) {
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
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(children: [const Text('Running Devices')]),
        ),

        // Thẻ các thiết bị
        Expanded(
          flex: 3,
          child: Consumer<DevicesViewModel>(
            builder: (context, viewModel, _) {
              // Kiểm tra nếu ban đầu chưa có thiết bị nào => có nút thêm thiết bị
              if (viewModel.device.isEmpty) {
                return Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      viewModel.device.add(
                        Device(
                          name: 'New Device',
                          pathImageName: 'default_device',
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
    final viewModel = Provider.of<DevicesViewModel>(context);
    String icon = (viewModel.device[_count].isOn)
        ? "${viewModel.device[_count].pathImageName}_on.gif"
        : "${viewModel.device[_count].pathImageName}.png";

    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Expanded(flex: 2, child: Image.asset('assets/images/$icon')),
          Expanded(
            child: Text(
              "${viewModel.device[_count].name} is ${(viewModel.device[_count].isOn) ? 'Turn On' : 'Turn Off'}",
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text('Current: ${viewModel.device[_count].current}'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text('Voltage: ${viewModel.device[_count].voltage}'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text('Power: ${viewModel.device[_count].power}'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
