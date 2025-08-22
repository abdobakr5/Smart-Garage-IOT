import 'package:flutter/material.dart';

Widget customTextField({
  required TextEditingController controller,
  required String hint,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
}) {
  return SizedBox(
    width: 400,
    height: 50,
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFAF6767)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFA7C5EF),
            width: 5.0,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "This field is required";
        }
        return null;
      },
    ),
  );
}
