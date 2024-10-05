import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    required this.title,
    required this.content,
    required this.positiveButtonText,
    required this.negativeButtonText,
    required this.onPositivePressed,
    required this.onNegativePressed,
    super.key,
  });
  final String title;
  final String content;
  final String positiveButtonText;
  final String negativeButtonText;
  final VoidCallback onPositivePressed;
  final VoidCallback onNegativePressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(content),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildRoundedButton(
                    context,
                    negativeButtonText,
                    Colors.redAccent,
                    onNegativePressed,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  flex: 2,
                  child: _buildRoundedButton(
                    context,
                    positiveButtonText,
                    Colors.greenAccent,
                    onPositivePressed,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedButton(
    BuildContext context,
    String text,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

Future<void> showCustomDialog(
  BuildContext context, {
  required String title,
  required String content,
  required String positiveButtonText,
  required String negativeButtonText,
  required VoidCallback onPositivePressed,
  required VoidCallback onNegativePressed,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(
        title: title,
        content: content,
        positiveButtonText: positiveButtonText,
        negativeButtonText: negativeButtonText,
        onPositivePressed: onPositivePressed,
        onNegativePressed: onNegativePressed,
      );
    },
  );
}
