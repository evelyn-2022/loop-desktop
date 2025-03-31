import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.white_800,
        colorScheme: ColorScheme.light(
            primary: AppColors.green_800,
            secondary: AppColors.grey_300,
            surface: AppColors.yellow_100,
            error: AppColors.error,
            onPrimary: AppColors.white_800,
            onSurface: AppColors.black_700,
            outline: AppColors.grey_100,
            outlineVariant: AppColors.grey_300),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16,
            color: AppColors.black_700,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              color: AppColors.grey_100,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              color: AppColors.grey_200,
              width: 1.5,
            ),
          ),
          hintStyle: TextStyle(
            color: AppColors.grey_200,
          ),
          labelStyle: TextStyle(
            color: AppColors.grey_200,
          ),
          floatingLabelStyle:
              WidgetStateTextStyle.resolveWith((states) {
            if (states.contains(WidgetState.focused)) {
              return TextStyle(color: AppColors.grey_300);
            }
            return TextStyle(color: AppColors.grey_200);
          }),
          contentPadding: EdgeInsets.symmetric(
              horizontal: 20, vertical: 16),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.yellow_400,
          selectionColor:
              AppColors.yellow_200.withValues(alpha: 96),
          selectionHandleColor:
              AppColors.primary, // draggable dot
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green_800,
            foregroundColor: AppColors.white_800,
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        iconTheme: const IconThemeData(
          color: AppColors.grey_100,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            backgroundColor:
                WidgetStateProperty.all(Colors.transparent),
            overlayColor:
                WidgetStateProperty.all(Colors.transparent),
            padding:
                WidgetStateProperty.all(EdgeInsets.zero),
            minimumSize: WidgetStateProperty.all(Size.zero),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.black_800,
        colorScheme: ColorScheme.dark(
          primary: AppColors.yellow_400,
          secondary: AppColors.grey_300,
          surface: AppColors.black_700,
          error: AppColors.error,
          onPrimary: AppColors.black_800,
          onSurface: Colors.white,
          outline: AppColors.grey_400,
          outlineVariant: AppColors.grey_200,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
              fontSize: 16, color: AppColors.white_700),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.red,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              color: AppColors.grey_400,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              color: AppColors.grey_200,
              width: 1.5,
            ),
          ),
          hintStyle: TextStyle(
            color: AppColors.grey_400,
          ),
          labelStyle: TextStyle(
            color: AppColors.grey_300,
          ),
          floatingLabelStyle:
              WidgetStateTextStyle.resolveWith((states) {
            if (states.contains(WidgetState.focused)) {
              return TextStyle(color: AppColors.grey_200);
            }
            return TextStyle(color: AppColors.grey_300);
          }),
          contentPadding: EdgeInsets.symmetric(
              horizontal: 20, vertical: 16),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.yellow_200,
          selectionColor:
              AppColors.yellow_200.withValues(alpha: 96),
          selectionHandleColor: AppColors.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.yellow_300,
              foregroundColor: AppColors.black_800,
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              )),
        ),
        iconTheme: const IconThemeData(
          color: AppColors.grey_400,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            backgroundColor:
                WidgetStateProperty.all(Colors.transparent),
            overlayColor:
                WidgetStateProperty.all(Colors.transparent),
            padding:
                WidgetStateProperty.all(EdgeInsets.zero),
            minimumSize: WidgetStateProperty.all(Size.zero),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      );
}
