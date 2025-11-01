import 'package:flutter/material.dart';
import 'package:num_1_test/models/room.dart';
import 'package:num_1_test/routing/app_routes.dart';
import 'package:num_1_test/state/room_provider.dart';
import 'package:num_1_test/ui/config_screen/config_room_card.dart';
// import 'package:num_1_test/ui/devices_screen/devices_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../../models/room.dart';
// import '../../state/room_provider.dart';
// import '../config_screen/config_room_card.dart';
import 'room_card.dart';
import 'package:num_1_test/ui/widgets/show_icon_options.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isToggle = false;
  late AnimationController _animationController;
  bool isLongPress = false;
  bool isPress = false;
  bool state = false;
  bool isShowIconMenu = false;

  Future<void> _onAddRoom(BuildContext context) async {
    final room = await Navigator.push<Room>(
      context,
      MaterialPageRoute(builder: (_) => const ConfigRoomCard()),
    );
    if (room != null && context.mounted) {
      await context.read<RoomProvider>().add(room);
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  void _toggleMenu() {
    setState(() {
      isToggle = !isToggle;
      isShowIconMenu = !isShowIconMenu;

      isToggle
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final rooms = context.watch<RoomProvider>().rooms;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Rooms'),
        actions: [
          IconButton(
            onPressed: _toggleMenu,
            icon: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _animationController,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAddRoom(context),
        child: const Icon(Icons.add),
      ),
      body: rooms.isEmpty
          ? Stack(
              children: [
                const Center(
                  child: Text('Chưa có phòng nào. Hãy bấm + để thêm!'),
                ),

                // Hiển thị hoặc tắt khi bấm vào icon 3 gạch trên thanh AppBar
                if (isShowIconMenu) ShowIconOptions(isShowMenu: isShowIconMenu),
              ],
            )
          : Stack(
              children: [
                GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: rooms.length,
                  itemBuilder: (context, i) {
                    final r = rooms[i];
                    return RoomCard(
                      title: r.title,
                      imagePath: r.imagePath,
                      deviceCount: r.deviceCount,
                      initialState: r.initialState,

                      onTap: () {
                        // Điều hướng tới trang hiển thị thiết bị của phòng
                        Navigator.pushNamed(
                          context,
                          AppRoutes
                              .livingRoom, // chưa thay đổi dữ liệu theo từng phòng
                          arguments: r, // truyền dữ liệu phòng qua
                        );
                      },

                      onLongPress: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.black,
                              title: const Text('Confirm Delete Room'),
                              content: Text(
                                'Are you sure you want to delete the "${r.title}\'room"?\nThis action will deleting all devices in this room!',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        if (shouldDelete == true && context.mounted) {
                          context.read<RoomProvider>().removeById(r.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Deleted "${r.title}"'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },

                      // ##### PHẦN ĐÃ SỬA (Lưu trạng thái Activate/Deactivate) #####
                      onDoubleTap: () {
                        // 1. Lấy RoomProvider
                        final roomProvider = context.read<RoomProvider>();

                        // 2. Tạo một bản sao của phòng với trạng thái (initialState) bị đảo ngược
                        final updatedRoom = r.copyWith(
                          initialState: !r.initialState,
                        );

                        // 3. Yêu cầu Provider cập nhật phòng này (việc này sẽ tự động lưu vào SharedPreferences)
                        roomProvider.update(updatedRoom);
                      },
                      // ##### KẾT THÚC PHẦN SỬA #####
                    );
                  },
                ),

                // Hiển thị hoặc tắt khi bấm vào icon 3 gạch trên thanh AppBar
                if (isShowIconMenu) ShowIconOptions(isShowMenu: isShowIconMenu),
              ],
            ),
    );
  }
}

class MyAlertDialog extends StatefulWidget {
  const MyAlertDialog({super.key});

  @override
  State<MyAlertDialog> createState() => _MyAlertDialogState();
}

class _MyAlertDialogState extends State<MyAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
