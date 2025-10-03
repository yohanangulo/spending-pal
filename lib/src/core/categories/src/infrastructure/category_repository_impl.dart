import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/config/debug/logger/log.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/core/categories/infrastructure.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(
    this._logger,
    this._categoryLocalDatasource,
    this._categoryRemoteDatasource,
  );

  final CategoryLocalDatasource _categoryLocalDatasource;
  final CategoryRemoteDatasource _categoryRemoteDatasource;
  final Log _logger;

  @override
  Stream<List<Category>> watchCategories(String userId) {
    return _categoryLocalDatasource.watchAll();
  }

  @override
  Future<Either<CategoryFailure, List<Category>>> fetchCategories() async {
    try {
      final res = await _categoryRemoteDatasource.getCategories();

      final categories = res.map((e) => e.toDomain()).toList();

      await _categoryLocalDatasource.upsertAll(categories);

      return right(categories);
    } catch (e, s) {
      _logger.e('Error fetching categories', e, s);

      return left(const CategoryFailure.unexpected());
    }
  }

  @override
  Future<Either<CategoryFailure, Unit>> deleteCategory(String id) async {
    final current = await _categoryLocalDatasource.findOneById(id);
    try {
      await _categoryLocalDatasource.delete(id);
      await _categoryRemoteDatasource.deleteCategory(id);

      return right(unit);
    } catch (e, s) {
      _logger.e('Error deleting category', e, s);

      await _categoryLocalDatasource.insert(current);

      return left(const CategoryFailure.unexpected());
    }
  }

  @override
  Future<Either<CategoryFailure, Unit>> createCategory(CreateCategoryDto dto) async {
    try {
      final res = await _categoryRemoteDatasource.createCategory(dto);
      await _categoryLocalDatasource.insert(res.toDomain());

      return right(unit);
    } catch (e, s) {
      _logger.e('Error creating category', e, s);

      return left(const CategoryFailure.unexpected());
    }
  }

  @override
  Future<Either<CategoryFailure, Unit>> updateCategory(Category category) async {
    final current = await _categoryLocalDatasource.findOneById(category.id);

    try {
      await _categoryLocalDatasource.upsert(category);

      await _categoryRemoteDatasource.updateCategory(category, category.id);

      return right(unit);
    } catch (e, s) {
      _logger.e('Error updating category', e, s);

      await _categoryLocalDatasource.insert(current);

      return left(const CategoryFailure.unexpected());
    }
  }
}
