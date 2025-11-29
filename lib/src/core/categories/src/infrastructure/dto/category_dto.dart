import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spending_pal/src/config/database/app_database.dart';
import 'package:spending_pal/src/core/categories/domain.dart';

part 'category_dto.freezed.dart';
part 'category_dto.g.dart';

@freezed
abstract class CategoryDto with _$CategoryDto {
  factory CategoryDto({
    required String id,
    required String name,
    required int icon,
    required int color,
    required String userId,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isDeleted,
  }) = _CategoryDto;

  const CategoryDto._();

  factory CategoryDto.fromJson(Map<String, dynamic> json) => _$CategoryDtoFromJson(json);

  factory CategoryDto.fromModel(CategoryModel category) => CategoryDto(
    id: category.id,
    name: category.name,
    icon: category.icon,
    color: category.color,
    userId: category.userId,
    createdAt: category.createdAt,
    updatedAt: category.updatedAt,
  );

  factory CategoryDto.fromDomain(Category category) => CategoryDto(
    id: category.id,
    name: category.name,
    icon: category.icon.codePoint,
    color: category.color.toARGB32(),
    userId: category.userId,
    createdAt: category.createdAt,
    updatedAt: category.updatedAt,
  );

  CategoryModel toModel() => CategoryModel(
    id: id,
    name: name,
    icon: icon,
    color: color,
    userId: userId,
    isDeleted: isDeleted,
    syncStatus: SyncStatus.synced.index,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  Category toDomain() => Category(
    userId: userId,
    id: id,
    name: name,
    icon: IconData(icon, fontFamily: 'MaterialIcons'),
    color: Color(color),
    createdAt: createdAt,
    updatedAt: updatedAt,
    expenseCount: 0,
  );
}
