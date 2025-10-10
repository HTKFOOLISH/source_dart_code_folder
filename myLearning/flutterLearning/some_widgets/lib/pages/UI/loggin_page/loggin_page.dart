import 'package:flutter/material.dart';
import 'package:some_widgets/constants.dart';
import 'package:some_widgets/pages/UI/loggin_page/text.dart';
import 'input_field_and_titletext.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        child: Scrollbar(
          child: Center(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 150),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/images/bug.png'),
                        height: 120,
                      ),
                      SizedBox(width: 20),
                      Image(
                        image: AssetImage('assets/images/smart-house.png'),
                        width: 250,
                      ),
                    ],
                  ),
                  TitleText(),
                  const SizedBox(height: 20),
                  InputForm(
                    focusNode: _usernameFocus,
                    label: labelTextUsername,
                    controller: _usernameController,
                    isPassword: false,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  InputForm(
                    focusNode: _passwordFocus,
                    label: labelTextPassword,
                    controller: _passwordController,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 20),
                  // Login Button
                  SizedBox(
                    height: 50,
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        print('Username: $_usernameController');
                        print('Username: $_passwordController');
                        // ElevatedButtonTheme.of(context).
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
