import 'package:flutter/material.dart';

Widget buildMenuButton(BuildContext context, String text, VoidCallback onPressed) {
  return Center(
    child: SizedBox(
      width: 250,
      height: 70,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 15,
          ),
          backgroundColor: Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          side: const BorderSide(color: Colors.blueAccent),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFAF6767),
          ),
        ),
      ),
    ),
  );
}
