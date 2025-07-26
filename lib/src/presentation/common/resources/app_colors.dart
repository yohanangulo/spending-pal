import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primary = Color(0xFF00DD94);
  static Color primaryLight = primary.withValues(alpha: 0.1);
  static const Color secondary = Color(0xFF1a1617);
  static const Color tertiary = Color(0xFFe9f3f0);
  static const Color destructive = Color(0xFFF44336);
  static Color destructiveLight = destructive.withValues(alpha: 0.1);
}
