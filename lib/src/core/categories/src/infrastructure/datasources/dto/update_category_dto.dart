import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_category_dto.freezed.dart';
part 'update_category_dto.g.dart';

@freezed
abstract class UpdateCategoryDto with _$UpdateCategoryDto {
  factory UpdateCategoryDto({
    @JsonKey(includeIfNull: false) String? id,
    @JsonKey(includeIfNull: false) String? name,
    @JsonKey(includeIfNull: false) int? icon,
    @JsonKey(includeIfNull: false) int? color,
    @JsonKey(includeIfNull: false) String? userId,
  }) = _UpdateCategoryDto;

  factory UpdateCategoryDto.fromJson(Map<String, dynamic> json) => _$UpdateCategoryDtoFromJson(json);
}
