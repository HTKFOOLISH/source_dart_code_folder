import 'dart:ui';

import 'package:flutter/material.dart';
import 'text.dart';

// Văn bản tiêu đề cho loggin page
class TitleText extends StatelessWidget {
  const TitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      titleText,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 50,
        height: 3.5,
        // overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// ********** UI cho trường nhập liệu đăng nhập **********

class InputForm extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputAction textInputAction;
  final FocusNode focusNode;

  const InputForm({
    super.key,
    required this.label,
    required this.controller,
    required this.isPassword,
    required this.textInputAction,
    required this.focusNode,
  });

  @override
  State<StatefulWidget> createState() => _InputForm();
}

class _InputForm extends State<InputForm> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 70,
      child: TextField(
        focusNode: widget.focusNode,
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        decoration: InputDecoration(
          hintText: widget.label,
          labelText: widget.label,
          floatingLabelStyle: TextStyle(color: Colors.black, fontSize: 26),
          prefixIcon: Icon(
            widget.isPassword
                ? Icons.lock_outline
                : Icons.account_circle_outlined,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                )
              : FocusScope(
                  canRequestFocus: false,
                  child: IconButton(
                    onPressed: () {
                      widget.controller.clear();
                    },
                    icon: Icon(Icons.clear),
                  ),
                ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.green, width: 3),
          ),
        ),
        style: TextStyle(color: const Color.fromARGB(214, 56, 3, 3)),
        keyboardType: TextInputType.text,
        obscuringCharacter: widget.isPassword ? '*' : '_',
        textInputAction: widget.textInputAction,
        onEditingComplete: () => widget.isPassword
            ? FocusScope.of(context).unfocus()
            : FocusScope.of(context).nextFocus(),
      ),
    );
  }
}
