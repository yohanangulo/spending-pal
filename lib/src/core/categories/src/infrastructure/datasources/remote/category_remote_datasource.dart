import 'package:spending_pal/src/core/categories/infrastructure.dart';

abstract class CategoryRemoteDatasource {
  Stream<List<CategoryDto>> watch();

  Future<List<CategoryDto>> getCategories();

  Future<CategoryDto> createCategory(CategoryDto categoryData);

  Future<List<CategoryDto>> createCategories(List<CategoryDto> categoriesData);

  Future<void> updateCategory(CategoryDto category);

  Future<void> deleteCategory(String id);
}
