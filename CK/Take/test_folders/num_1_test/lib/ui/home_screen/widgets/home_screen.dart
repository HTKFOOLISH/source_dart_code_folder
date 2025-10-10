import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(title: const Text('Home Screen')),
    //   body: const Center(child: Text('Welcome to the Home Screen!')),
    // );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(color: Color(0xFF4C7380)),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  child: Container(
                    // width: Get.width,
                    decoration: BoxDecoration(
                      color: Color(0xFF4C7380),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Stack(
                        //       children: [
                        //         RenderSvg(
                        //           path: 'home_top_cloud',
                        //           width: 80,
                        //         ),
                        //         Positioned(
                        //           top: 40            ,
                        //           child: Text(
                        //             text: 'Good Morning,',
                        //             fontSize: 20,
                        //             color: Colors.white,
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //     RenderSvg(
                        //       path: 'top_left_cloud',
                        //       width: 80,
                        //     ),
                        //   ],
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Goood Morning,',
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Text('Kimberly Mastrangelo'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 15,
                                top: 35,
                                bottom: 20,
                              ),
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(
                                  Icons.notifications,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.zero,
                              padding: EdgeInsets.zero,
                              // height: Get.height / 4.6,
                              // width: Get.width,
                            ),
                            Positioned(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Container(
                                  height: 166,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade100,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 15,
                                              left: 12,
                                              right: 12,
                                            ),
                                            child: Image.asset(
                                              height: 60,
                                              'bug.png',
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                              left: 3,
                                              right: 3,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'May 16, 2023 10:05 am',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                  // fontSize: 12,
                                                ),
                                                const Text(
                                                  'Cloudy',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                  // fontSize: 18,
                                                ),
                                                const Text(
                                                  'Jakara, Indonesia',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                  // fontSize: 12,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Row(
                                            children: [
                                              const Text(
                                                '19\$degree',
                                                style: TextStyle(fontSize: 42),
                                              ),
                                              const Text(
                                                'c',
                                                style: TextStyle(fontSize: 42),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        child: Divider(color: Colors.grey[500]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              height: 63,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.grey.shade200,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 4,
                                                        ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Container(
                                                          height: 35,
                                                          width: 35,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  50,
                                                                ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  5.0,
                                                                ),
                                                            child: Image.asset(
                                                              'smart-house.png',
                                                              height: 15,
                                                              width: 15,
                                                            ),
                                                          ),
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 25,
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text: '97',
                                                              ),
                                                              WidgetSpan(
                                                                child: Transform.translate(
                                                                  offset:
                                                                      const Offset(
                                                                        0.0,
                                                                        0.0,
                                                                      ),
                                                                  child: Text(
                                                                    '%',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Text(
                                                    'Humadity',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 63,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.grey.shade200,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 4,
                                                        ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Container(
                                                          height: 35,
                                                          width: 35,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  50,
                                                                ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  7.0,
                                                                ),
                                                            child: Image.asset(
                                                              'eye.png',
                                                              height: 15,
                                                              width: 15,
                                                            ),
                                                          ),
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 25,
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text: '7',
                                                              ),
                                                              WidgetSpan(
                                                                child: Transform.translate(
                                                                  offset:
                                                                      const Offset(
                                                                        0.0,
                                                                        0.0,
                                                                      ),
                                                                  child: Text(
                                                                    'km',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Text(
                                                    'Visibility',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 63,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.grey.shade100,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 4,
                                                        ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Container(
                                                          height: 35,
                                                          width: 35,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  50,
                                                                ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  5.0,
                                                                ),
                                                            child: Image.asset(
                                                              'sonofoll.png',
                                                              height: 15,
                                                              width: 15,
                                                            ),
                                                          ),
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 25,
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text: '3',
                                                              ),
                                                              WidgetSpan(
                                                                child: Transform.translate(
                                                                  offset:
                                                                      const Offset(
                                                                        0.0,
                                                                        0.0,
                                                                      ),
                                                                  child: Text(
                                                                    'km/h',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Text(
                                                    'NE Wind',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Image.asset('bug.png'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 9,
            child: Container(
              // height: Get.height / 1.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(40)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 15,
                      bottom: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Rooms', style: TextStyle(fontSize: 16)),
                        const Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 5),
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Color(0xFFD8E4E8),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10, top: 10),
                                  height: 25,
                                  width: 52,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF4C7380),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                        children: [
                                          TextSpan(text: '19\$degree'),
                                          WidgetSpan(
                                            child: Transform.translate(
                                              offset: const Offset(0.0, 2.0),
                                              child: Text(
                                                'c',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Image.asset(
                                    'living-room.png',
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                                Center(
                                  child: const Text(
                                    'Living Room',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 25,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFE266),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 2,
                                          vertical: 3,
                                        ),
                                        child: Center(
                                          child: const Text(
                                            '5',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      ' devices',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 15),
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Color(0xFFD8E4E8),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10, top: 10),
                                  height: 25,
                                  width: 52,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF4C7380),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                        children: [
                                          TextSpan(text: '19\$degree'),
                                          WidgetSpan(
                                            child: Transform.translate(
                                              offset: const Offset(0.0, 2.0),
                                              child: Text(
                                                'c',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Image.asset(
                                    'bedroom.png',
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Living Room',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 25,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFE266),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 2,
                                          vertical: 3,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '8',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      ' devices',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 15,
                      bottom: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Active', style: TextStyle(fontSize: 16)),
                        Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 5),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Color(0xFF9A7265),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Image.asset(
                                        // path: 'air-conditioner.png',
                                        'bug.png',
                                        height: 65,
                                        width: 65,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10,
                                          ),
                                          child: Text(
                                            'Temprature',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                            ),
                                            children: [
                                              TextSpan(text: '19\$degree'),
                                              WidgetSpan(
                                                child: Transform.translate(
                                                  offset: const Offset(
                                                    0.0,
                                                    5.0,
                                                  ),
                                                  child: Text(
                                                    'c',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 5,
                                        bottom: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'AC',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            'Living room',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // AnimatedToggleSwitch<bool>.dual(
                                    //   current: positive,
                                    //   first: false,
                                    //   second: true,
                                    //   dif: 10.0,
                                    //   borderColor: Colors.transparent,
                                    //   borderWidth: 3.0,
                                    //   height: 22,
                                    //   indicatorSize: Size(25, 16),
                                    //   boxShadow: const [
                                    //     BoxShadow(
                                    //       color: Colors.black26,
                                    //       spreadRadius: 1,
                                    //       blurRadius: 2,
                                    //       offset: Offset(0, .5),
                                    //     ),
                                    //   ],
                                    //   onChanged: (b) {
                                    //     setState(() => positive = b);
                                    //     return Future.delayed(
                                    //       Duration(seconds: 1),
                                    //     );
                                    //   },
                                    //   colorBuilder: (b) =>
                                    //       b ? Colors.yellow[900] : Colors.teal,
                                    //   iconBuilder: (value) => value
                                    //       ? Icon(
                                    //           Icons.coronavirus_rounded,
                                    //           size: 15,
                                    //           color: Colors.white,
                                    //         )
                                    //       : Icon(
                                    //           Icons.tag_faces_rounded,
                                    //           size: 15,
                                    //           color: Color(0xFFffffff),
                                    //         ),
                                    //   textBuilder: (value) => value
                                    //       ? Center(
                                    //           child: Text(
                                    //             text: 'ON',
                                    //             fontSize: 9,
                                    //             fontWeight: FontWeight.w500,
                                    //             color: Colors.white,
                                    //           ),
                                    //         )
                                    //       : Center(
                                    //           child: Text(
                                    //             text: 'OFF',
                                    //             fontSize: 9,
                                    //             fontWeight: FontWeight.w500,
                                    //             color: Colors.white,
                                    //           ),
                                    //         ),
                                    // ),
                                    // AdvancedSwitch(
                                    //   activeColor: Color(0xFF659A6E),
                                    //   activeChild: Text(
                                    //     text: 'ON',
                                    //     color: Colors.white,
                                    //     fontSize: 13,
                                    //   ),
                                    //   inactiveChild: Text(
                                    //     text: 'OFF',
                                    //     color: Colors.white,
                                    //     fontSize: 13,
                                    //   ),
                                    //   width: 56,
                                    //   height: 23,
                                    //   controller: _controller02,
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            // Get.to(DetailsPage());
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 15),
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                color: Color(0xFF9A7265),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child: Image.asset(
                                          // path: 'light-bulbs.png',
                                          'bug.png',
                                          height: 65,
                                          width: 65,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: Text(
                                                'Colour',
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'White',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 5,
                                          bottom: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Lamp',
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              'Dining room',
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          // AnimatedToggleSwitch<bool>.dual(
                                          //   current: positive2,
                                          //   first: false,
                                          //   second: true,
                                          //   dif: 10.0,
                                          //   borderColor: Colors.transparent,
                                          //   borderWidth: 3.0,
                                          //   height: 22,
                                          //   indicatorSize: Size(25, 16),
                                          //   boxShadow: const [
                                          //     BoxShadow(
                                          //       color: Colors.black26,
                                          //       spreadRadius: 1,
                                          //       blurRadius: 2,
                                          //       offset: Offset(0, .5),
                                          //     ),
                                          //   ],
                                          //   onChanged: (b) {
                                          //     setState(() => positive2 = b);
                                          //     return Future.delayed(
                                          //       Duration(seconds: 1),
                                          //     );
                                          //   },
                                          //   colorBuilder: (b) => b
                                          //       ? Colors.yellow[900]
                                          //       : Colors.teal,
                                          //   iconBuilder: (value) => value
                                          //       ? Icon(
                                          //           Icons.coronavirus_rounded,
                                          //           size: 15,
                                          //           color: Colors.white,
                                          //         )
                                          //       : Icon(
                                          //           Icons.tag_faces_rounded,
                                          //           size: 15,
                                          //           color: Color(0xFFffffff),
                                          //         ),
                                          //   textBuilder: (value) => value
                                          //       ? Center(
                                          //           child: Text(
                                          //             'ON',
                                          //             style: TextStyle(
                                          //               fontSize: 9,
                                          //               fontWeight:
                                          //                   FontWeight.w500,
                                          //               color: Colors.white,
                                          //             ),
                                          //           ),
                                          //         )
                                          //       : Center(
                                          //           child: Text(
                                          //             'OFF',
                                          //             style: TextStyle(
                                          //               fontSize: 9,
                                          //               fontWeight:
                                          //                   FontWeight.w500,
                                          //               color: Colors.white,
                                          //             ),
                                          //           ),
                                          //         ),
                                          // ),
                                        ],
                                      ),
                                      // AdvancedSwitch(
                                      //   activeColor: Color(0xFF659A6E),
                                      //   activeChild: Text(
                                      //     text: 'ON',
                                      //     color: Colors.white,
                                      //     fontSize: 13,
                                      //   ),
                                      //   inactiveChild: Text(
                                      //     text: 'OFF',
                                      //     color: Colors.white,
                                      //     fontSize: 13,
                                      //   ),
                                      //   width: 56,
                                      //   height: 23,
                                      //   controller: _controller03,
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Expanded(
                      //   flex: 1,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 5, right: 15),
                      //     child: Container(
                      //       height: 150,
                      //       decoration: BoxDecoration(
                      //           color: Color(0xFF9A7265),
                      //           borderRadius: BorderRadius.circular(10)),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
