import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

bool _isLoading = false;
Widget buildSocialButton({
  required String text,
  required String assetPath,
  required VoidCallback onPressed,
}) {
  return Container(
    width: double.infinity,
    height: 56,
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: OutlinedButton(
      onPressed: _isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(assetPath, height: 24, width: 24),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}
