import 'package:drift/drift.dart' hide JsonKey;
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
  }) = _CategoryDto;

  factory CategoryDto.fromJson(Map<String, dynamic> json) => _$CategoryDtoFromJson(json);

  const CategoryDto._();

  Category toDomain() {
    return Category(
      id: id,
      name: name,
      icon: IconData(icon, fontFamily: 'MaterialIcons'),
      color: Color(color),
      expenseCount: 0,
    );
  }

  CategoriesTableCompanion toCompanion() {
    return CategoriesTableCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      color: Value(color),
      userId: Value(userId),
    );
  }
}
