import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette - Minimal and soft
  static const Color primaryColor = Color(0xFF6B73FF); // Soft pastel accent
  static const Color backgroundColor = Color(0xFFFAFAFA); // Light gray background
  static const Color surfaceColor = Color(0xFFFFFFFF); // White surface
  static const Color textColor = Color(0xFF2C2C2C); // Dark gray text
  static const Color textSecondaryColor = Color(0xFF6B6B6B); // Medium gray text
  static const Color borderColor = Color(0xFFE0E0E0); // Light border
  static const Color errorColor = Color(0xFFFF6B6B); // Soft red
  static const Color successColor = Color(0xFF4CAF50); // Soft green

  // Typography
  static const String? fontFamily = null; // Use system default fonts

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        surface: surfaceColor,
        background: backgroundColor,
        onPrimary: Colors.white,
        onSurface: textColor,
        onBackground: textColor,
        error: errorColor,
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        // Mobile-optimized app bar
        toolbarHeight: 56.0,
        scrolledUnderElevation: 0,
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderColor, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        // Mobile-optimized input padding
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(color: textSecondaryColor),
        // Ensure touch targets are at least 48x48
        isDense: false,
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          // Mobile-optimized button padding
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          // Ensure minimum touch target size
          minimumSize: const Size(88, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          // Mobile-optimized padding
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          // Ensure minimum touch target size
          minimumSize: const Size(88, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      // Icon Button Theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          // Ensure minimum touch target size for icons
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.all(12),
        ),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textColor,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      
      // Scaffold Background
      scaffoldBackgroundColor: backgroundColor,
      
      // Mobile-optimized scrollbar
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all(primaryColor.withOpacity(0.3)),
        trackColor: MaterialStateProperty.all(borderColor.withOpacity(0.1)),
        thickness: MaterialStateProperty.all(6.0),
        radius: const Radius.circular(3.0),
      ),
      
      // Mobile-optimized divider
      dividerTheme: const DividerThemeData(
        color: borderColor,
        thickness: 1.0,
        space: 1.0,
      ),
      
      // Mobile-optimized bottom navigation bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),
    );
  }
}
