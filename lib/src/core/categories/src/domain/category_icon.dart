import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_icon.freezed.dart';

/// Domain value object representing a category icon.
/// Framework-agnostic - stores only the icon code point and font family.
@freezed
abstract class CategoryIcon with _$CategoryIcon {
  const factory CategoryIcon({
    required int codePoint,
    @Default('MaterialIcons') String fontFamily,
  }) = _CategoryIcon;

  const CategoryIcon._();

  /// Common Material Icons used for categories
  static const CategoryIcon restaurant = CategoryIcon(codePoint: 0xe532);
  static const CategoryIcon directionalsCar = CategoryIcon(codePoint: 0xe1d7);
  static const CategoryIcon shoppingBag = CategoryIcon(codePoint: 0xe5e8);
  static const CategoryIcon movie = CategoryIcon(codePoint: 0xe8b2);
  static const CategoryIcon medicalServices = CategoryIcon(codePoint: 0xe540);
  static const CategoryIcon electricBolt = CategoryIcon(codePoint: 0xe1e4);
  static const CategoryIcon home = CategoryIcon(codePoint: 0xe88a);
  static const CategoryIcon school = CategoryIcon(codePoint: 0xe86b);
  static const CategoryIcon sportsEsports = CategoryIcon(codePoint: 0xe30e);
  static const CategoryIcon flight = CategoryIcon(codePoint: 0xe539);
}
