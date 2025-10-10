// TODO Bước 1: Khai báo thư viện
import 'package:flutter/material.dart';

// TODO Bước 2: hàm main => hàm chính/hàm đầu tiên để chạy ứng dụng.
void main() {
  // TODO Bước 3: Khởi động ứng dụng
  runApp(const MyApp());
  print('\n************************ ===DONE==== ************************');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String appBarText = 'Flutter Demo App';
  final String bodyText = 'Hello Everyone 🎉🎉🎉 !';

  // TODO Bước 4: build widget
  @override
  Widget build(BuildContext context) {
    // block of codes here ...
    return MaterialApp(
      // TODO Bước 5: sử dụng các thành phần trong widget để xây dựng giao diện
      // cho ứng dụng.
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarText),
            backgroundColor: Colors.grey,
            centerTitle: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text(bodyText)),
              const MyWidget(isLoading: false),
              const MyWidget2(false),
            ],
          ),
        ),
      ),
    );
  }
}

// Ví dụ với StatelessWidget
class MyWidget extends StatelessWidget {
  final bool isLoading;

  const MyWidget({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) => isLoading
      ? const CircularProgressIndicator()
      : const Text(
          'Done from '
          'StatelessWidget',
        );
}

// Ví dụ với StatefulWidget
class MyWidget2 extends StatefulWidget {
  final bool isLoading;

  const MyWidget2(this.isLoading, {super.key});

  @override
  State<StatefulWidget> createState() => MyWidget2State();
}

class MyWidget2State extends State<MyWidget2> {
  late bool _isLoading;
  @override
  void initState() {
    _isLoading = widget.isLoading;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : FloatingActionButton(onPressed: onClickedBtn);
  }

  void onClickedBtn() {
    setState(() {
      _isLoading = true;
    });
  }
}
