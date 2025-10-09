import 'package:flutter/material.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';

abstract class Decorations {
  const Decorations._();

  static ButtonStyle get outlinedButton => ElevatedButton.styleFrom(
    disabledBackgroundColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.primary,
    disabledForegroundColor: const Color(0xFF757575),
    padding: const EdgeInsets.symmetric(horizontal: Dimens.p8, vertical: Dimens.p5),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    minimumSize: const Size(double.infinity, Dimens.p10),
    side: const BorderSide(
      color: AppColors.primary,
      width: 1.5,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Dimens.p2),
    ),
    elevation: 0,
    overlayColor: AppColors.primary.withValues(alpha: 0.04),
    splashFactory: NoSplash.splashFactory,
  );
}
