import 'package:dartz/dartz.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/core/categories/infrastructure.dart';

abstract class CategoryRepository {
  Stream<List<Category>> watchCategories(String userId);
  Future<Either<CategoryFailure, Unit>> createCategory(CreateCategoryDto dto);
  Future<void> updateCategory(String id, CreateCategoryDto dto);
  Future<void> deleteCategory(String id);
}
