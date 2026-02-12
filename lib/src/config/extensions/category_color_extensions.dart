import 'package:flutter/material.dart';
import 'package:spending_pal/src/core/categories/domain.dart';

/// Flutter-specific extensions for CategoryColor.
/// Provides conversion to Flutter's Color type.
extension CategoryColorFlutter on CategoryColor {
  /// Converts this CategoryColor to Flutter's Color.
  Color toColor() {
    return Color(value);
  }
}
