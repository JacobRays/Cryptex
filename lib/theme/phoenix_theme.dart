import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoenixTheme {
  // Colors
  static const Color blackPrimary = Color(0xFF121212);
  static const Color blackSecondary = Color(0xFF1E1E1E);
  static const Color goldPrimary = Color(0xFFD4AF37);
  static const Color goldSecondary = Color(0xFFE0C16A);
  static const Color greyDark = Color(0xFF2C2C2C);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color white = Color(0xFFFFFFFF);
  static const Color greyLight = Color(0xFF9E9E9E);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: goldPrimary,
      scaffoldBackgroundColor: blackPrimary,
      fontFamily: GoogleFonts.exo2().fontFamily,
      
      colorScheme: const ColorScheme.dark(
        primary: goldPrimary,
        secondary: goldSecondary,
        background: blackPrimary,
        surface: greyDark,
        error: error,
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: blackSecondary,
        elevation: 0,
        titleTextStyle: GoogleFonts.exo2(
          color: goldPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: goldPrimary),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: goldPrimary,
          foregroundColor: blackPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          textStyle: GoogleFonts.exo2(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      cardTheme: CardTheme(
        color: greyDark,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: goldPrimary, width: 0.5),
        ),
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: blackSecondary,
        selectedItemColor: goldPrimary,
        unselectedItemColor: greyLight,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}