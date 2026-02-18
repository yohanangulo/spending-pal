import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/config/common/conflict_resolver.dart';
import 'package:spending_pal/src/config/connectivity/connectivity_service.dart';
import 'package:spending_pal/src/config/debug/logger/log.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/core/categories/infrastructure.dart';
import 'package:spending_pal/src/core/common/common.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository, Syncable {
  CategoryRepositoryImpl(
    this._logger,
    this._categoryLocalDatasource,
    this._categoryRemoteDatasource,
    this._connectivityService,
    this._conflictResolver,
    this._syncStatesDao,
  );

  final CategoryLocalDatasource _categoryLocalDatasource;
  final CategoryRemoteDatasource _categoryRemoteDatasource;
  final ConnectivityService _connectivityService;
  final ConflictResolver _conflictResolver;
  final SyncStatesDao _syncStatesDao;
  final Log _logger;

  @override
  Stream<List<Category>> watchCategories(String userId) {
    return _categoryLocalDatasource.watchAll().map((e) => e.map(CategoryMapper.toDomain).toList());
  }

  @Deprecated('Use sync instead')
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
      await _categoryLocalDatasource.delete(id);

      if (!await _connectivityService.isConnected) return right(unit);

      unawaited(_upSync());

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

      unawaited(_upSync());

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

      unawaited(_upSync());

      return right(unit);
    } catch (e, s) {
      _logger.e('Error updating category', e, s);

      return left(const CategoryFailure.unexpected());
    }
  }

  @override
  Future<Either<CategoryFailure, Unit>> sync() async {
    try {
      _logger.i('Syncing categories');

      await _upSync();
      await _downSync();
      // await _categoryLocalDatasource.clearSyncedDeletes();

      _logger.i('Categories synced');

      return right(unit);
    } catch (e, s) {
      _logger.e('Error syncing categories', e, s);

      return left(const CategoryFailure.unexpected());
    }
  }

  Future<void> _upSync() async {
    final pendingCategories = await _categoryLocalDatasource.getPendingSync();

    for (final pendingCategory in pendingCategories) {
      final remoteCategory = await _categoryRemoteDatasource.getCategoryById(pendingCategory.id);

      if (remoteCategory == null) {
        await _categoryRemoteDatasource.upsert(CategoryDto.fromModel(pendingCategory));
        await _categoryLocalDatasource.upsert(pendingCategory.copyWith(syncStatus: SyncStatus.synced.index));

        continue;
      }

      final resolved = _conflictResolver.resolveLatest(local: pendingCategory, remote: remoteCategory.toModel());

      await resolved.fold(
        (local) async {
          await _categoryRemoteDatasource.upsert(CategoryDto.fromModel(local));
          await _categoryLocalDatasource.upsert(local.copyWith(syncStatus: SyncStatus.synced.index));
        },
        (remote) async {
          await _categoryLocalDatasource.upsert(remote.copyWith(syncStatus: SyncStatus.synced.index));
        },
      );
    }
  }

  Future<void> _downSync() async {
    final DateTime? lastSync = await _syncStatesDao.get<Category>();
    final remoteChanges = await _categoryRemoteDatasource.getUpdatedCategories(lastSync);

    _logger.i('Found ${remoteChanges.length} categories to downSync');

    for (final remoteItem in remoteChanges) {
      final localItem = await _categoryLocalDatasource.findOneById(remoteItem.id);

      if (localItem == null) {
        await _categoryLocalDatasource.upsert(remoteItem.toModel());

        continue;
      }

      final resolved = _conflictResolver.resolveLatest(local: localItem, remote: remoteItem.toModel());

      await resolved.fold(
        (local) async {
          await _categoryRemoteDatasource.upsert(CategoryDto.fromModel(local));
          await _categoryLocalDatasource.upsert(local.copyWith(syncStatus: SyncStatus.synced.index));
        },
        (remote) async {
          await _categoryLocalDatasource.upsert(remote.copyWith(syncStatus: SyncStatus.synced.index));
        },
      );
    }

    if (remoteChanges.isEmpty) return;

    final maxUpdated = remoteChanges.map((e) => e.updatedAt).maxOrNull!;
    await _syncStatesDao.set<Category>(maxUpdated);
  }
}
