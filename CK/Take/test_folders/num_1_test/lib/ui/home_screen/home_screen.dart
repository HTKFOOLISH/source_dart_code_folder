import 'package:flutter/material.dart';
import 'package:num_1_test/routing/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'add a new room',
        onPressed: () {},
        label: Row(
          children: [
            Icon(Icons.add, color: Colors.white),
            Padding(padding: EdgeInsets.fromLTRB(0, 0, 7, 0)),
            Text('Add room'),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('All Rooms'),
        leading: BackButton(
          onPressed: () => {
            Navigator.of(context).popAndPushNamed(AppRoutes.login),
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('You\'ve just logout'),
                duration: Duration(seconds: 2),
              ),
            ),
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 50, 12, 50),
        child: GridView.count(
          childAspectRatio: .90, // chỉnh tỉ lệ chiều cao từng thẻ
          crossAxisCount: 2, // 2 cột
          crossAxisSpacing: 5, // khoảng cách dọc
          mainAxisSpacing: 16, // khoảng cách ngang
          // Chứa các phòng
          children: [
            // Living Room
            InkWell(
              onTap: () => Navigator.pushNamed(context, AppRoutes.livingRoom),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  side: BorderSide(color: Colors.white60, width: 3),
                ),
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Padding(padding: EdgeInsets.all(15)),
                    Image.asset('assets/images/Living_room.png'),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: const Text(
                        'Living Room',
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
                          'Deactivate', // tắt đèn thì chuyển màu và ngc lại
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red, // đổi màu để tắt hết đèn
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                  ],
                ),
              ),
            ),

            // Bed Room
            InkWell(
              onTap: () => Navigator.pushNamed(context, AppRoutes.livingRoom),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  side: BorderSide(color: Colors.white60, width: 3),
                ),
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Padding(padding: EdgeInsets.all(15)),
                    Image.asset('assets/images/bed_room.png'),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: const Text(
                        'Bed Room',
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
                          'Deactivate', // tắt đèn thì chuyển màu và ngc lại
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red, // đổi màu để tắt hết đèn
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                  ],
                ),
              ),
            ),

            // Kitchen
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                side: BorderSide(color: Colors.white60, width: 3),
              ),
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Padding(padding: EdgeInsets.all(15)),
                  Image.asset('assets/images/kitchen.png'),
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: const Text(
                      'Kitchen',
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
                        'Activate', // tắt đèn thì chuyển màu và ngc lại
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green, // đổi màu để tắt hết đèn
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                ],
              ),
            ),

            // Garage
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                side: BorderSide(color: Colors.white60, width: 3),
              ),
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Padding(padding: EdgeInsets.all(15)),
                  Image.asset('assets/images/garage.png'),
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: const Text(
                      'Garage',
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
                        'Deactivate', // tắt đèn thì chuyển màu và ngc lại
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red, // đổi màu để tắt hết đèn
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                ],
              ),
            ),

            // Garden
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                side: BorderSide(color: Colors.white60, width: 3),
              ),
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Padding(padding: EdgeInsets.all(15)),
                  Image.asset('assets/images/garden.png'),
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: const Text(
                      'Garden',
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
                        'Activate', // tắt đèn thì chuyển màu và ngc lại
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green, // đổi màu để tắt hết đèn
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                ],
              ),
            ),

            // Reading Room
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                side: BorderSide(color: Colors.white60, width: 3),
              ),
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Padding(padding: EdgeInsets.all(15)),
                  Image.asset('assets/images/reading.png'),
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: const Text(
                      'Reading Room',
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
                        'Activate', // tắt đèn thì chuyển màu và ngc lại
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green, // đổi màu để tắt hết đèn
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                ],
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                side: BorderSide(color: Colors.white60, width: 3),
              ),
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Padding(padding: EdgeInsets.all(15)),
                  Image.asset('assets/images/Living_room.png'),
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: const Text(
                      'Living Room',
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
                        'Deactivate', // tắt đèn thì chuyển màu và ngc lại
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red, // đổi màu để tắt hết đèn
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
