import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spending_pal/src/config/database/app_database.dart';

part 'create_category_dto.freezed.dart';

@freezed
abstract class CreateCategoryDto with _$CreateCategoryDto {
  factory CreateCategoryDto({
    required String name,
    required int icon,
    required int color,
    required String userId,
  }) = _CreateCategoryDto;

  const CreateCategoryDto._();

  CategoriesTableCompanion toCompanion() {
    return CategoriesTableCompanion.insert(
      name: name,
      icon: icon,
      color: color,
      userId: userId,
    );
  }
}
