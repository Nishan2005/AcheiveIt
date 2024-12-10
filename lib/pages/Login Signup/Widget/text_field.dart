import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final IconData? icon;
  final TextInputType textInputType;
  const TextFieldInput({
    super.key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    this.icon,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: TextField(
        style: const TextStyle(fontSize: 16),
        controller: textEditingController,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black54),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black45, fontSize: 16),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15),
          ),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
            borderRadius: BorderRadius.circular(15),
          ),
          filled: true,
          fillColor: const Color(0xFFedf0f8),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 15,
          ),
        ),
        keyboardType: textInputType,
        obscureText: isPass,
      ),
    );
  }
}
