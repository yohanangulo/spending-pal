import 'package:dartz/dartz.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/core/categories/infrastructure.dart';

abstract class CategoryRepository {
  Stream<List<Category>> watchCategories(String userId);
  Future<Either<CategoryFailure, List<Category>>> fetchCategories();
  Future<Either<CategoryFailure, Unit>> createCategory(CreateCategoryDto dto);
  Future<Either<CategoryFailure, Unit>> updateCategory(Category category);
  Future<Either<CategoryFailure, Unit>> deleteCategory(String id);
}
