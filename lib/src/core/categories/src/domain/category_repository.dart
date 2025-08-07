import 'package:spending_pal/src/core/categories/domain.dart';

abstract class CategoryRepository {
  Future<void> saveCategory(Category category);
  Future<void> deleteCategory(Category category);
  Stream<List<Category>> watchCategories(String userId);
}
