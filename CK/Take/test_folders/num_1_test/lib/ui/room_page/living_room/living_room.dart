import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:num_1_test/ui/room_page/devices_view_model.dart';

class LivingRoom extends StatefulWidget {
  const LivingRoom({super.key});

  @override
  State<StatefulWidget> createState() => LivingRoomState();
}

class LivingRoomState extends State<LivingRoom>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/IoT_logo.png'),
            const Padding(
              padding: EdgeInsets.only(right: 18.0),
              child: Text('Living Room'),
            ),
            IconButton(
              onPressed: () {
                if (_controller.status == AnimationStatus.completed) {
                  _controller.reverse();
                } else {
                  _controller.forward();
                }
              },
              icon: AnimatedIcon(
                icon: AnimatedIcons.menu_arrow,
                progress: _controller,
              ),
            ),
          ],
        ),
      ),
      body: ChangeNotifierProvider(
        create: (_) => DevicesViewModel(),
        child: LivingRoomBodyScreen(),
      ),
    );
  }
}

class LivingRoomBodyScreen extends StatefulWidget {
  const LivingRoomBodyScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LivingRoomBodyScreenState();
}

class _LivingRoomBodyScreenState extends State<LivingRoomBodyScreen> {
  bool isOnTap = false;
  int count = 0;

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
              return ListView.builder(
                itemCount: viewModel.device.length,
                itemBuilder: (context, index) {
                  final device = viewModel.device[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        count = index;
                        isOnTap = true;
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        side: BorderSide(color: Colors.white60, width: 3),
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
                          onChanged: (value) {
                            Provider.of<DevicesViewModel>(
                              context,
                              listen: false,
                            ).toggleDevice(device, value);
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
  // bool isOn => widget.

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DevicesViewModel>(context);
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Image.asset(
              'assets/images/${viewModel.device[_count].pathImageName}.png',
              scale: .5,
            ),
          ),
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
                    child: Text('Current: ${viewModel.device[_count].current}'),
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
