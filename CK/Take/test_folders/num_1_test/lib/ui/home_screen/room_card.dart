import 'package:flutter/material.dart';

class RoomCard extends StatefulWidget {
  final String title;
  final String imagePath;
  final int deviceCount;
  final bool initialState;
  final Function()? onTap;
  final Function()? onLongPress;
  final Function()? onDoubleTap;

  const RoomCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.deviceCount,
    this.initialState = false,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
  });

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  bool state = false;
  bool isPress = false;
  bool isLongPress = false;

  @override
  void initState() {
    super.initState();
    state = widget.initialState;
  }

  @override
  Widget build(BuildContext context) {
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

        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            isPress = false;
            state = !state;
          });
        });

        widget.onDoubleTap?.call(); // Gọi callback từ HomeScreen
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Devices: 4', // 4 là số lượng thiết bị hiện có
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  state
                      ? 'Activate'
                      : 'Deactivate', // tắt đèn thì chuyển màu và ngc lại
                  style: TextStyle(
                    fontSize: 16,
                    color: state
                        ? Colors.green
                        : Colors.red, // đổi màu để tắt hết đèn
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
