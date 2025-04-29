import 'package:flutter/material.dart';

class AppTheme {
  static const Color neonYellow = Color(0xFFE6FF00);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkGrey = Color(0xFF1E1E1E);
  static const Color sectionTitleColor = Color(0xFFE6FF00);
  static const Color sectionSubtitleColor = Color(0xFFB3B3B3);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: neonYellow,
      onPrimary: darkBackground,
      surface: darkGrey,
      onSurface: Colors.white,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: -1,
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.1,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 16,
        letterSpacing: 0.15,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontSize: 14,
        letterSpacing: 0.1,
      ),
      labelLarge: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkGrey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: neonYellow),
      ),
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIconColor: Colors.grey,
      hintStyle: const TextStyle(color: Colors.grey),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return neonYellow.withOpacity(0.5);
          }
          return neonYellow;
        }),
        foregroundColor: MaterialStateProperty.all(darkBackground),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
    ),
  );
}
