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

  factory Category.fromDb({
    required String id,
    required String name,
    required int icon,
    required int color,
  }) {
    return Category(
      id: id,
      name: name,
      icon: IconData(icon, fontFamily: 'MaterialIcons'),
      color: Color(color),
      expenseCount: 0,
    );
  }

  static List<Category> initialCategories = [
    Category(
      id: '1',
      name: 'Alimentación',
      icon: const IconData(0xe532, fontFamily: 'MaterialIcons'),
      color: const Color(0xffff0000),
      expenseCount: 0,
    ),
    Category(
      id: '2',
      name: 'Transporte',
      icon: const IconData(0xe1d7, fontFamily: 'MaterialIcons'),
      color: const Color(0xffff0000),
      expenseCount: 0,
    ),
    Category(
      id: '3',
      name: 'Entretenimiento',
      icon: const IconData(0xe5e8, fontFamily: 'MaterialIcons'),
      color: const Color(0xFFff0000),
      expenseCount: 0,
    ),
  ];
}
