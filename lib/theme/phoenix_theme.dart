import 'package:flutter/material.dart';

class PhoenixTheme {
  static const Color goldPrimary = Color(0xFFFFD700);
  static const Color goldSecondary = Color(0xFFFFA500);
  static const Color blackPrimary = Color(0xFF000000);
  static const Color blackSecondary = Color(0xFF1A1A1A);
  static const Color greyDark = Color(0xFF2A2A2A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);

  static ThemeData darkGoldTheme = ThemeData(
    primaryColor: goldPrimary,
    scaffoldBackgroundColor: blackPrimary,
    brightness: Brightness.dark,
    
    appBarTheme: AppBarTheme(
      backgroundColor: blackSecondary,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: goldPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: goldPrimary),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: goldPrimary,
        foregroundColor: blackPrimary,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: greyDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: goldPrimary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: goldPrimary.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: goldPrimary, width: 2),
      ),
      labelStyle: TextStyle(color: goldPrimary),
      hintStyle: TextStyle(color: Colors.grey),
    ),
  );
}
