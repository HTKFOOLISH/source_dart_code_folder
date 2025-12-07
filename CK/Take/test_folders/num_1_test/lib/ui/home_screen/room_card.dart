// room_card.dart

import 'package:flutter/material.dart';

class RoomCard extends StatefulWidget {
  final String title;
  final String imagePath;
  final int deviceCount;
  final bool initialState; // Trạng thái này giờ do RoomProvider quyết định
  final Function()? onTap;
  final Function()? onLongPress; // <-- Phải có ở đây
  final Function()? onDoubleTap; // <-- Phải có ở đây

  const RoomCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.deviceCount,
    this.initialState = false,
    this.onTap,
    this.onLongPress, // <-- Phải có ở đây
    this.onDoubleTap, // <-- Phải có ở đây
  });

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  // bool state = false; // <-- [ĐÃ XOÁ] Không cần tự quản lý state nữa
  bool isPress = false;
  bool isLongPress = false;

  @override
  void initState() {
    super.initState();
    // state = widget.initialState; // <-- [ĐÃ XOÁ]
  }

  @override
  Widget build(BuildContext context) {
    // Lấy trạng thái trực tiếp từ widget (do provider cung cấp)
    final bool state = widget.initialState;

    return InkWell(
      onLongPress: () {
        setState(() {
          isLongPress = true; // tạm thời đổi màu khi giữ lâu
        });

        // Gọi hàm xóa từ widget cha (HomeScreen)
        widget.onLongPress?.call();

        // Sau một chút thì trở lại màu ban đầu (hiệu ứng nhấn)
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              isLongPress = false;
            });
          }
        });
      },

      onDoubleTap: () {
        setState(() {
          isPress = true;
        });

        // Chỉ gọi hàm onDoubleTap (đã được định nghĩa ở HomeScreen)
        widget.onDoubleTap?.call();

        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            // Thêm kiểm tra 'mounted' cho an toàn
            setState(() {
              isPress = false;
              // state = !state; // <-- [ĐÃ XOÁ] Không tự thay đổi state ở đây
            });
          }
        });
      },

      onTap: widget.onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isPress ? Colors.blue : Colors.black,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white60, width: 3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Padding(padding: EdgeInsets.all(15)),
            Image.asset(widget.imagePath),
            Padding(
              padding: EdgeInsets.all(0),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Wrap(
              alignment: WrapAlignment.spaceAround,
              children: [
                Text(
                  'Devices: ${widget.deviceCount}', // Lấy từ widget
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  state
                      ? 'Activate'
                      : 'Deactivate', // Dùng 'state' đã lấy từ widget
                  style: TextStyle(
                    fontSize: 16,
                    color: state
                        ? Colors.green
                        : Colors.red, // Dùng 'state' đã lấy từ widget
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(5)),
          ],
        ),
      ),
    );
  }
}
