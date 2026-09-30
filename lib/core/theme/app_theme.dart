import 'package:flutter/material.dart';

class AppTheme {

  /// COLOR TOKENS

  /// Light Mode Tokens
  static const Color _lightCanvas = Color(0xFFFBFBFB);
  static const Color _lightContainer = Color(0xFFF1F3F3);
  static const Color _lightPrimary = Color(0xFF0F3D3E);

  /// Dark Mode Tokens
  static const Color _darkCanvas = Color(0xFF121515);
  static const Color _darkContainer = Color(0xFF1D2222);
  static const Color _darkPrimary = Color(0xFF4DB6AC);

  /// Light Theme Configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _lightCanvas,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _lightPrimary,
        brightness: Brightness.light,
        surface: _lightContainer,
        primary: _lightPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightCanvas,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: _lightPrimary),
      ),
      cardTheme: CardThemeData(
        color: _lightContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Dark Theme Configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkCanvas,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _darkPrimary,
        brightness: Brightness.dark,
        surface: _darkContainer,
        primary: _darkPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkCanvas,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: _darkPrimary),
      ),
      cardTheme: CardThemeData(
        color: _darkContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimary,
          foregroundColor: _darkCanvas, // High-contrast dark text on mint button
          elevation: 0,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}