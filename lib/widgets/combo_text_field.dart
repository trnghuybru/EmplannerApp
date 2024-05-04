import 'package:flutter/material.dart';

class ComboTextField extends StatelessWidget {
  const ComboTextField({
    super.key,
    required this.title,
    required this.hintText,
    required this.isPassword,
    required this.controller,
  });

  final String title;
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 250, 187, 24),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
        ),
        obscureText: isPassword,
      ),
    );
  }
}
