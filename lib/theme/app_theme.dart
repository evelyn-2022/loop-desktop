import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        // fontFamily: 'Inter',
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          background: AppColors.background,
          surface: AppColors.surface,
          error: AppColors.error,
          onPrimary: Colors.white,
          onBackground: AppColors.text,
          onSurface: AppColors.text,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
              fontSize: 16, color: AppColors.text),
          headlineMedium: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.text),
          labelLarge: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.text),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
                vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        // fontFamily: 'Inter',
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          background: Colors.black,
          surface: const Color(0xFF1E1E1E),
          error: AppColors.error,
          onPrimary: Colors.white,
          onBackground: Colors.white,
          onSurface: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium:
              TextStyle(fontSize: 16, color: Colors.white),
          headlineMedium: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          labelLarge: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
                vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
}
