// import 'package:flutter/material.dart';

// class LoginViewModel extends ChangeNotifier {
//   final username = TextEditingController();
//   final password = TextEditingController();
//   final usernameFocus = FocusNode();
//   final passwordFocus = FocusNode();

//   bool submitted = false;
//   bool obscure = true;

//   void toggleObscure() {
//     obscure = !obscure;
//     notifyListeners();
//   }

//   Future<void> submit(BuildContext context) async {
//     submitted = true;
//     notifyListeners();
//     final userEmpty = username.text.trim().isEmpty;
//     final passEmpty = password.text.isEmpty;
//     if (userEmpty) {
//       usernameFocus.requestFocus();
//       return;
//     }
//     if (passEmpty) {
//       passwordFocus.requestFocus();
//       return;
//     }
//     // TODO: gọi AuthRepository.login(...)
//     if (!(userEmpty && passEmpty)) {
//       await Future.delayed(
//         Duration(seconds: 2),
//         () => ElevatedButton.icon(
//           onPressed: () => CircularProgressIndicator(strokeWidth: 2),
//           label: Text('Loading...'),
//         ),
//       );
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Login successful!')));
//       print('object');
//       return;
//     }
//   }

//   void disposeAll() {
//     username.dispose();
//     password.dispose();
//     usernameFocus.dispose();
//     passwordFocus.dispose();
//   }
// }
