import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

enum SyncStatus {
  pending,
  synced,
  syncing,
  error,
}

@freezed
abstract class Category with _$Category {
  factory Category({
    required String id,
    required String userId,
    required String name,
    required IconData icon,
    required Color color,
    required int expenseCount,
    // required SyncStatus syncStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Category;

  const Category._();

  static List<Category> initialCategories(String userId) {
    final now = DateTime.now();
    return [
      Category(
        id: '',
        name: 'Alimentación',
        icon: const IconData(0xe532, fontFamily: 'MaterialIcons'),
        color: const Color(0xffff0000),
        expenseCount: 0,
        userId: userId,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: '',
        name: 'Transporte',
        icon: const IconData(0xe1d7, fontFamily: 'MaterialIcons'),
        color: const Color(0xffff0000),
        expenseCount: 0,
        userId: userId,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: '',
        name: 'Entretenimiento',
        icon: const IconData(0xe5e8, fontFamily: 'MaterialIcons'),
        color: const Color(0xFFff0000),
        expenseCount: 0,
        userId: userId,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
