import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spending_pal/src/core/categories/src/domain/category_color.dart';
import 'package:spending_pal/src/core/categories/src/domain/category_icon.dart';

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
    required CategoryIcon icon,
    required CategoryColor color,
    required int expenseCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Category;

  factory Category.empty() => Category(
    id: '',
    userId: '',
    name: '',
    icon: CategoryIcon.restaurant,
    color: CategoryColor.red,
    expenseCount: 0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  const Category._();

  bool get isEmpty => Category.empty() == this;

  static List<Category> initialCategories(String userId) {
    final now = DateTime.now();
    return [
      Category(
        id: '',
        name: 'Alimentación',
        icon: CategoryIcon.restaurant,
        color: CategoryColor.amber,
        expenseCount: 0,
        userId: userId,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: '',
        name: 'Transporte',
        icon: CategoryIcon.directionalsCar,
        color: CategoryColor.red,
        expenseCount: 0,
        userId: userId,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: '',
        name: 'Entretenimiento',
        icon: CategoryIcon.shoppingBag,
        color: CategoryColor.purple,
        expenseCount: 0,
        userId: userId,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
