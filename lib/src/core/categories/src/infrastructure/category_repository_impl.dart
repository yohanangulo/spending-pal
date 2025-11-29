import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/config/connectivity/connectivity_service.dart';
import 'package:spending_pal/src/config/debug/logger/log.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/core/categories/infrastructure.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(
    this._logger,
    this._categoryLocalDatasource,
    this._categoryRemoteDatasource,
    this._connectivityService,
  );

  final CategoryLocalDatasource _categoryLocalDatasource;
  final CategoryRemoteDatasource _categoryRemoteDatasource;
  final ConnectivityService _connectivityService;
  final Log _logger;

  @override
  Stream<List<Category>> watchCategories(String userId) {
    return _categoryLocalDatasource.watchAll().map((e) => e.map(CategoryMapper.toDomain).toList());
  }

  @override
  Future<Either<CategoryFailure, List<Category>>> fetchCategories() async {
    try {
      final dtos = await _categoryRemoteDatasource.getCategories();

      final categories = dtos.map((e) => e.toModel()).toList();

      await _categoryLocalDatasource.upsertAll(categories);

      return right(dtos.map((e) => e.toDomain()).toList());
    } catch (e, s) {
      _logger.e('Error fetching categories', e, s);

      return left(const CategoryFailure.unexpected());
    }
  }

  @override
  Future<Either<CategoryFailure, Unit>> deleteCategory(String id) async {
    try {
      final current = await _categoryLocalDatasource.findOneById(id);
      await _categoryLocalDatasource.delete(id);

      if (!await _connectivityService.isConnected) return right(unit);

      try {
        final synced = current.copyWith(isDeleted: true, syncStatus: SyncStatus.synced.index);

        await _categoryRemoteDatasource.deleteCategory(id);
        await _categoryLocalDatasource.upsert(synced);
      } catch (e, s) {
        _logger.e('Remote sync failed, keeping pending', e, s);
      }

      return right(unit);
    } catch (e, s) {
      _logger.e('Error deleting category', e, s);

      return left(const CategoryFailure.unexpected());
    }
  }

  @override
  Future<Either<CategoryFailure, Unit>> createCategory(Category category) async {
    try {
      final categoryModel = CategoryMapper.toModel(category);
      await _categoryLocalDatasource.insert(categoryModel);

      if (!await _connectivityService.isConnected) return right(unit);

      await _categoryRemoteDatasource.createCategory(CategoryDto.fromDomain(category));
      await _categoryLocalDatasource.upsert(categoryModel.copyWith(syncStatus: SyncStatus.synced.index));

      return right(unit);
    } catch (e, s) {
      _logger.e('Error creating category', e, s);

      return left(const CategoryFailure.unexpected());
    }
  }

  @override
  Future<Either<CategoryFailure, Unit>> updateCategory(Category category) async {
    try {
      final categoryModel = CategoryMapper.toModel(category);
      await _categoryLocalDatasource.upsert(categoryModel);

      if (!await _connectivityService.isConnected) return right(unit);

      await _categoryRemoteDatasource.updateCategory(CategoryDto.fromDomain(category));
      await _categoryLocalDatasource.upsert(categoryModel.copyWith(syncStatus: SyncStatus.synced.index));

      return right(unit);
    } catch (e, s) {
      _logger.e('Error updating category', e, s);

      return left(const CategoryFailure.unexpected());
    }
  }

  Future<void> sync() async {}
}
