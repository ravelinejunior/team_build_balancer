import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.radius = 30.0,
    this.width = 200.0,
    this.height = 48.0,
    this.fontSize = 14.0,
  });
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double radius;
  final double width;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
