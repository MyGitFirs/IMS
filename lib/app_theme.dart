import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme {
    final baseTheme = ThemeData.light();

    return baseTheme.copyWith(
      primaryColor: const Color(0xFF4B5563), // Steel gray
      hintColor: const Color(0xFF6B7280), // Cool gray for accents
      scaffoldBackgroundColor: const Color(0xFFF4F4F5), // Light gray background
      cardColor: const Color(0xFFE5E7EB), // Soft gray for cards
      canvasColor: const Color(0xFFF3F4F6), // Slightly darker gray for drawer and canvas
      textTheme: baseTheme.textTheme.copyWith(
        bodyLarge: const TextStyle(color: Colors.black87),
        bodyMedium: const TextStyle(color: Color(0xFF374151)), // Dark gray for secondary text
        titleLarge: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: const TextStyle(
          color: Color(0xFF4B5563),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.black87),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFE5E7EB), // Light gray for input fields
        hintStyle: const TextStyle(color: Color(0xFF6B7280)), // Subtle gray hints
        labelStyle: const TextStyle(color: Color(0xFF374151)), // Darker gray labels
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF9CA3AF)), // Medium gray border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF9CA3AF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF4B5563)), // Steel gray on focus
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF4B5563), // Steel gray app bar
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: const Color(0xFF4B5563),
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF4B5563),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF4B5563),
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFE5E7EB),
        selectedItemColor: Color(0xFF4B5563),
        unselectedItemColor: Color(0xFF9CA3AF),
      ),
    );
  }
}
