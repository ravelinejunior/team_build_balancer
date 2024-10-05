import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData mainThemeData() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.poppins().fontFamily,
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(),
      bodyMedium: GoogleFonts.poppins(),
      bodySmall: GoogleFonts.poppins(),
      titleLarge: GoogleFonts.montserrat(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      titleMedium: GoogleFonts.montserrat(),
      titleSmall: GoogleFonts.montserrat(),
    ),
  );
}
