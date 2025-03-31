import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loop/theme/app_dimensions.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.white_800,
        colorScheme: ColorScheme.light(
            primary: AppColors.green_800,
            secondary: AppColors.grey_200,
            surface: AppColors.yellow_100,
            error: AppColors.red_200,
            onPrimary: AppColors.white_800,
            onSurface: AppColors.black_700,
            outline: AppColors.grey_100,
            outlineVariant: AppColors.grey_300),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.bitter(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: AppColors.black_800,
          ),
          headlineMedium: GoogleFonts.bitter(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: AppColors.black_800,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: AppColors.black_800,
          ),
          bodySmall: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.grey_300,
          ),
          // Button text style
          labelLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: AppColors.black_800,
          ),
          // Link text style
          labelSmall: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: AppColors.yellow_400,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.yellow_400,
            decorationThickness:
                AppDimensions.strokeWidthMd,
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
          selectionHandleColor: AppColors.yellow_400,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.resolveWith<Color>(
                    (states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.green_700;
              }
              return AppColors.green_800;
            }),
            foregroundColor:
                WidgetStateProperty.resolveWith<Color>(
                    (states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.white_700;
              }
              return AppColors.white_800;
            }),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(
                vertical:
                    AppDimensions.buttonPaddingVertical,
                horizontal:
                    AppDimensions.buttonPaddingHorizontal,
              ),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    AppDimensions.buttonBorderRadius),
              ),
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
          error: AppColors.red_200,
          onPrimary: AppColors.black_800,
          onSurface: AppColors.white_700,
          outline: AppColors.grey_400,
          outlineVariant: AppColors.grey_200,
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.bitter(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: AppColors.white_700,
          ),
          headlineMedium: GoogleFonts.bitter(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: AppColors.white_700,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: AppColors.white_700,
          ),
          bodySmall: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.grey_300,
          ),
          // Button text style
          labelLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: AppColors.white_700,
          ),
          // Link text style
          labelSmall: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: AppColors.yellow_300,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.yellow_300,
            decorationThickness:
                AppDimensions.strokeWidthMd,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  AppDimensions.textFieldBorderRadius),
              borderSide: BorderSide(
                  width: AppDimensions.strokeWidthMd)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.grey_400,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.grey_200,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.red_200,
              // width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.red_200,
              width: AppDimensions.strokeWidthLg,
            ),
          ),
          errorStyle: TextStyle(
            fontSize: 12,
            color: AppColors.red_200,
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
              horizontal:
                  AppDimensions.textFieldPaddingHorizontal,
              vertical:
                  AppDimensions.textFieldPaddingVertical),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.yellow_200,
          selectionColor:
              AppColors.yellow_200.withValues(alpha: 96),
          selectionHandleColor: AppColors.yellow_200,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.resolveWith<Color>(
                    (states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.yellow_200;
              }
              return AppColors.yellow_300;
            }),
            foregroundColor:
                WidgetStateProperty.resolveWith<Color>(
                    (states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.black_700;
              }
              return AppColors.black_800;
            }),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(
                vertical:
                    AppDimensions.buttonPaddingVertical,
                horizontal:
                    AppDimensions.buttonPaddingHorizontal,
              ),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    AppDimensions.buttonBorderRadius),
              ),
            ),
          ),
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
