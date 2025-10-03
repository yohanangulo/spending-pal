import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_category_dto.freezed.dart';
part 'create_category_dto.g.dart';

@freezed
abstract class CreateCategoryDto with _$CreateCategoryDto {
  factory CreateCategoryDto({
    required String name,
    required int icon,
    required int color,
    required String userId,
    String? id,
  }) = _CreateCategoryDto;

  const CreateCategoryDto._();

  factory CreateCategoryDto.fromJson(Map<String, dynamic> json) => _$CreateCategoryDtoFromJson(json);
}
