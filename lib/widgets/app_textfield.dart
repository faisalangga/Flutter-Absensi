import 'package:sas_hima/constant/const_color.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  AppTextField(
      {Key? key,
        required this.labelText,
        required this.controller,
        this.keyboardType = TextInputType.text,
        this.autofocus = false,
        this.isReadOnly = false,
        this.isPassword = false})
      : super(key: key);

  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool autofocus;
  final bool isPassword;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: isReadOnly,
      controller: this.controller,
      autofocus: this.autofocus,
      cursorColor: secondaryColors,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: labelText,
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[200],
        enabledBorder: new OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
        focusedBorder: new OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
      ),
      obscureText: isPassword,
      keyboardType: keyboardType,
    );
  }
}