import 'package:dartz/dartz.dart';
import 'package:spending_pal/src/core/categories/domain.dart';

abstract class CategoryRepository {
  Stream<List<Category>> watchCategories(String userId);

  @Deprecated('Use sync instead')
  Future<Either<CategoryFailure, List<Category>>> fetchCategories();

  Future<Either<CategoryFailure, Unit>> createCategory(Category category);

  Future<Either<CategoryFailure, Unit>> updateCategory(Category category);

  Future<Either<CategoryFailure, Unit>> deleteCategory(String id);

  Future<Either<CategoryFailure, Unit>> sync();
}
