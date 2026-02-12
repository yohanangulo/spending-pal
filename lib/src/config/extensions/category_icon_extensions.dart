import 'package:flutter/material.dart';
import 'package:spending_pal/src/core/categories/domain.dart';

/// Flutter-specific extensions for CategoryIcon.
/// Provides conversion to Flutter's IconData type.
extension CategoryIconFlutter on CategoryIcon {
  /// Converts this CategoryIcon to Flutter's IconData.
  IconData toIconData() {
    return IconData(
      codePoint,
      fontFamily: fontFamily,
    );
  }
}
