import 'package:flutter/material.dart';
import '../../routing/app_routes.dart';

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

  void _handleSubmit() async {
    setState(() {
      _submitted = true; // từ giờ trở đi mới hiện lỗi nếu trống
    });

    final userEmpty = _usernameController.text.trim().isEmpty;
    final passEmpty = _passwordController.text.isEmpty;

    if (!userEmpty && !passEmpty) {
      await Future.delayed(const Duration(milliseconds: 500));

      // TODO: Trỏ tới trang home_screen (all room)
      // Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      Navigator.of(context).popAndPushNamed(AppRoutes.home);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Successful!'),
          duration: Duration(seconds: 2),
        ),
      );
      // TODO: gọi API đăng nhập thật sự ở đây
    } else {
      // Đưa focus tới ô sai đầu tiên cho tiện nhập
      if (userEmpty) {
        _usernameFocus.requestFocus();
      } else if (passEmpty) {
        _passwordFocus.requestFocus();
      }
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

  // static const String labelTextUsername = 'Username';
  // static const String labelTextPassword = 'Password';
  // final LoginViewModel loginViewModel = LoginViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LOGO
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Image(image: AssetImage('assets/images/bug.png')),
                  Image(image: AssetImage('assets/images/smart-house.png')),
                ],
              ),

              // TITLE
              const Text(
                'BUG HOME',
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  height: 3.0,
                ),
              ),

              // USERNAME
              SizedBox(
                width: 350,
                height: 100, // tăng nhẹ để đủ chỗ hiển thị error
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
                width: 350,
                height: 100,
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
                      color: Colors.white,
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

              // SIGN IN BUTTON (luôn bấm được)
              SizedBox(
                height: 90,
                width: 350,
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
