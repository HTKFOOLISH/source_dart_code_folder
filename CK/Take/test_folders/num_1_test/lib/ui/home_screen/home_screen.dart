import 'package:flutter/material.dart';
import 'package:num_1_test/models/room.dart';
import 'package:num_1_test/routing/app_routes.dart';
import 'package:num_1_test/state/room_provider.dart';
import 'package:num_1_test/ui/config_screen/config_room_card.dart';
import 'package:provider/provider.dart';
// import '../../models/room.dart';
// import '../../state/room_provider.dart';
// import '../config_screen/config_room_card.dart';
import 'room_card.dart';

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
        leading: BackButton(
          onPressed: () => {
            Navigator.popAndPushNamed(context, AppRoutes.login),
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('You\'ve just logout'),
                duration: Duration(milliseconds: 200),
              ),
            ),
          },
        ),
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
                  // ShowIconOptions(isShowMenu: ,)
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
                      onLongPress: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.black,
                              title: const Text('Xác nhận xóa phòng'),
                              content: Text(
                                'Bạn có chắc chắn muốn xóa "${r.title}" không?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Hủy'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    'Xóa',
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
                              content: Text('Đã xóa phòng "${r.title}"'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },

                      onDoubleTap: () {
                        print("Double tap on room ${r.title}");
                      },
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

class ShowIconOptions extends StatefulWidget {
  final bool isShowMenu;
  const ShowIconOptions({super.key, required this.isShowMenu});

  @override
  State<ShowIconOptions> createState() => _ShowIconOptionsState();
}

class _ShowIconOptionsState extends State<ShowIconOptions> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 5,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(15),
        ),
        child: Column(
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
            IconButton(onPressed: () {}, icon: Icon(Icons.info)),
            IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (_) => false,
                );
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
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
