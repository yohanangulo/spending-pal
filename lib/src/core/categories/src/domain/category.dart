import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

@freezed
abstract class Category with _$Category {
  factory Category({
    required String id,
    required String name,
    required IconData icon,
    required Color color,
    required int expenseCount,
  }) = _Category;

  const Category._();
}
