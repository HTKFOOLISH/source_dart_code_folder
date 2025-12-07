// login_screen.dart

import 'package:flutter/material.dart';
import 'package:num_1_test/state/user_provider.dart'; // <-- THÊM VÀO
import 'package:provider/provider.dart'; // <-- THÊM VÀO
import 'package:shared_preferences/shared_preferences.dart';
import '../../routing/app_routes.dart';

// CHANGE: import MQTT để hiển thị trạng thái và đảm bảo kết nối sau login
import 'package:num_1_test/mqtt/mqtt_config.dart'; // CHANGE
import 'package:num_1_test/mqtt/mqtt_service.dart'; // CHANGE

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _isObscure = true;

  static const String labelTextUsername = 'Username';
  static const String labelTextPassword = 'Password';

  // Cờ cho biết đã bấm Sign In lần đầu hay chưa
  bool _submitted = false;

  // ##### PHẦN SỬA #####
  String? _loginError; // Biến lưu thông báo lỗi
  // ##### KẾT THÚC PHẦN SỬA #####

  // CHANGE: Đảm bảo MQTT đã kết nối (dùng config đã lưu)
  Future<void> _ensureMqttConnected() async {
    try {
      final cfg = await MqttConfig.load();
      if (cfg == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('MQTT config chưa được thiết lập!')),
        );
        return;
      }
      await MqttService.I.connect(cfg);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Kết nối MQTT lỗi: $e')));
    }
  }

  void _handleSubmit() async {
    setState(() {
      _submitted = true; // từ giờ trở đi mới hiện lỗi nếu trống
      _loginError = null; // Xóa lỗi cũ mỗi lần bấm
    });

    final String username = _usernameController.text.trim();
    final String password = _passwordController.text;

    final userEmpty = username.isEmpty;
    final passEmpty = password.isEmpty;

    if (userEmpty) {
      _usernameFocus.requestFocus();
      return;
    }
    if (passEmpty) {
      _passwordFocus.requestFocus();
      return;
    }

    // ##### PHẦN SỬA: LOGIC XÁC THỰC #####
    final userProvider = context.read<UserProvider>();
    final bool isValid = userProvider.validate(username, password);

    if (isValid) {
      // Đăng nhập đúng -> Lưu lại user/pass (để auto-fill) và chuyển trang
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      await prefs.setString('password', password);

      // CHANGE: Đảm bảo MQTT sẵn sàng sau đăng nhập (nếu lúc mở app chưa vào được)
      await _ensureMqttConnected(); // CHANGE

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Successful!'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Đăng nhập sai -> Hiển thị lỗi
      setState(() {
        _loginError = 'Invalid username or password. Please try again.';
      });
      _passwordFocus.requestFocus();
    }
    // ##### KẾT THÚC PHẦN SỬA #####
  }

  // ----- TỰ ĐỘNG ĐIỀN THÔNG TIN KHI MỞ APP -----

  // đọc lại dữ liệu đã lưu trong initState()
  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  void _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUser = prefs.getString('username') ?? '';
    final savedPass = prefs.getString('password') ?? '';

    // Chỉ tự điền nếu có cả 2
    if (savedUser.isNotEmpty && savedPass.isNotEmpty) {
      setState(() {
        _usernameController.text = savedUser;
        _passwordController.text = savedPass;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // CHANGE: Hiển thị trạng thái MQTT
    final connectionStream = MqttService.I.connection; // CHANGE

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LOGO
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Image(image: AssetImage('assets/images/bug.png')),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Image(
                        image: AssetImage('assets/images/smart-house.png'),
                      ),
                    ),
                  ],
                ),
              ),

              // TITLE
              Text(
                'BUG HOME',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.15, // fit th
                  fontWeight: FontWeight.bold,
                  height: MediaQuery.of(context).size.height * 0.003,
                ),
              ),

              // CHANGE: Thanh trạng thái MQTT (Connected/Disconnected)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: StreamBuilder<bool>(
                  stream: connectionStream,
                  initialData: MqttService.I.isConnected,
                  builder: (context, snap) {
                    final ok = snap.data == true;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          ok ? Icons.cloud_done : Icons.cloud_off,
                          color: ok ? Colors.lightGreen : Colors.redAccent,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          ok ? 'MQTT Connected' : 'MQTT Disconnected',
                          style: TextStyle(
                            fontSize: 16,
                            color: ok ? Colors.lightGreen : Colors.redAccent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: _ensureMqttConnected, // thử reconnect
                          child: const Text('Reconnect'),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // END CHANGE

              // USERNAME
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.12,
                child: TextField(
                  focusNode: _usernameFocus,
                  controller: _usernameController,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Colors.white, width: 3),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(
                        color: Colors.lightGreen,
                        width: 3,
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Colors.red, width: 3),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Colors.red, width: 3),
                    ),
                    labelText: labelTextUsername,
                    labelStyle: TextStyle(color: Colors.white),
                    floatingLabelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                    hintText: 'Enter your username',
                    hintStyle: const TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                    ),
                    // Hiển thị lỗi CHỈ sau khi đã bấm Sign In
                    errorText:
                        _submitted && _usernameController.text.trim().isEmpty
                        ? 'Username cannot be empty'
                        : null,
                    errorStyle: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                    prefixIcon: const Icon(
                      Icons.person_outlined,
                      color: Colors.white,
                    ),
                    suffixIcon: FocusScope(
                      canRequestFocus: false,
                      child: IconButton(
                        onPressed: () => _usernameController.clear(),
                        icon: const Icon(Icons.clear, color: Colors.white),
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),

              // PASSWORD
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.12,
                child: TextField(
                  focusNode: _passwordFocus,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Colors.white, width: 3),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(
                        color: Colors.lightGreen,
                        width: 3,
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Colors.red, width: 3),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Colors.red, width: 3),
                    ),
                    labelText: labelTextPassword,
                    labelStyle: TextStyle(color: Colors.white),
                    floatingLabelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                    ),
                    // Lỗi chỉ hiện sau khi đã bấm Sign In
                    errorText: _submitted && _passwordController.text.isEmpty
                        ? 'Password cannot be empty'
                        : null,
                    errorStyle: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.white,
                    ),
                    suffixIcon: FocusScope(
                      canRequestFocus: false,
                      child: IconButton(
                        onPressed: () =>
                            setState(() => _isObscure = !_isObscure),
                        icon: Icon(
                          _isObscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  obscureText: _isObscure,
                  obscuringCharacter: '*',
                  textInputAction: TextInputAction.done,
                ),
              ),

              // ##### PHẦN SỬA: HIỂN THỊ LỖI #####
              if (_loginError != null)
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12.0,
                    left: 24,
                    right: 24,
                  ),
                  child: Text(
                    _loginError!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              // ##### KẾT THÚC PHẦN SỬA #####

              // SIGN IN BUTTON (luôn bấm được)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
                width: MediaQuery.of(context).size.width * 0.85,
                child: ElevatedButton(
                  onPressed: () => _handleSubmit(), // GỌI hàm thật sự
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
