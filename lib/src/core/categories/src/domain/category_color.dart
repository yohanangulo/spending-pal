import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_color.freezed.dart';

/// Domain value object representing a category color.
/// Framework-agnostic - stores only the ARGB32 integer value.
@freezed
abstract class CategoryColor with _$CategoryColor {
  const factory CategoryColor({
    required int value,
  }) = _CategoryColor;

  const CategoryColor._();

  /// Common colors used for categories (ARGB32 format)
  static const CategoryColor blue = CategoryColor(value: 0xFF2196F3);
  static const CategoryColor green = CategoryColor(value: 0xFF4CAF50);
  static const CategoryColor orange = CategoryColor(value: 0xFFFF9800);
  static const CategoryColor red = CategoryColor(value: 0xFFFF0000);
  static const CategoryColor purple = CategoryColor(value: 0xFF9C27B0);
  static const CategoryColor pink = CategoryColor(value: 0xFFE91E63);
  static const CategoryColor teal = CategoryColor(value: 0xFF009688);
  static const CategoryColor indigo = CategoryColor(value: 0xFF3F51B5);
  static const CategoryColor amber = CategoryColor(value: 0xFFFFC107);
  static const CategoryColor cyan = CategoryColor(value: 0xFF00BCD4);
}
