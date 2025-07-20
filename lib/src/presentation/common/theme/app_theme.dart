import 'package:flutter/material.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/custom_outline_input_border.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      // ===== Scaffold background color =====
      scaffoldBackgroundColor: const Color.fromARGB(255, 252, 252, 252),

      // ===== Snack bar theme =====
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),

      // ===== App bar theme =====
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: AppColors.secondary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),

      // ===== Color scheme =====
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
      ),

      // ===== Text theme =====
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: const Color(0xFFD9D9D9),
          padding: const EdgeInsets.symmetric(horizontal: Dimens.p8, vertical: Dimens.p5),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.secondary,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          minimumSize: const Size(double.infinity, Dimens.p10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.p2),
          ),
        ),
      ),

      // ===== Input decoration theme =====
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        hintStyle: const TextStyle(
          color: Colors.black,
        ),
        errorMaxLines: 2,
        filled: true,
        fillColor: AppColors.tertiary,
        border: CustomOutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.p2),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        enabledBorder: CustomOutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.p2),
          borderSide: BorderSide.none,
        ),
        errorBorder: CustomOutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.p2),
        ),
        focusedBorder: CustomOutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.p2),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),
    );
  }
}
