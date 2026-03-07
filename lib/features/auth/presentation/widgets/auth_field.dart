import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  String hintText;
  TextEditingController controller;
  bool isObscureText;
  FocusNode? focusNode;
  VoidCallback? onFieldSubmitted;
  AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.focusNode,
    this.onFieldSubmitted,
    this.isObscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onFieldSubmitted: (value) {
        if (onFieldSubmitted != null) {
          onFieldSubmitted!();
        }
      },
      obscureText: isObscureText,
      decoration: InputDecoration(hintText: hintText),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $hintText';
        }
        return null;
      },
    );
  }
}
