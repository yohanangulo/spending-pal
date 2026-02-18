import 'package:spending_pal/src/config/database/app_database.dart';
import 'package:spending_pal/src/core/categories/domain.dart';

class CategoryMapper {
  static Category toDomain(CategoryModel category) {
    return Category(
      id: category.id,
      userId: category.userId,
      name: category.name,
      color: CategoryColor(value: category.color),
      icon: CategoryIcon(codePoint: category.icon),
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
      transactionCount: 0,
    );
  }

  static CategoryModel toModel(
    Category category, {
    bool isDeleted = false,
    SyncStatus syncStatus = SyncStatus.pending,
  }) {
    return CategoryModel(
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
      id: category.id,
      name: category.name,
      icon: category.icon.codePoint,
      color: category.color.value,
      userId: category.userId,
      isDeleted: false,
      syncStatus: syncStatus.index,
    );
  }
}
