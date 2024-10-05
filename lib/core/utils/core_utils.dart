import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoreUtils {
  const CoreUtils._();

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(12),
        ),
      );
  }
}
