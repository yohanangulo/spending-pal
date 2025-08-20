import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/config/database/app_database.dart';
import 'package:spending_pal/src/config/database/tables/db_dto_extensions/db_dto_extensions.dart';
import 'package:spending_pal/src/config/debug/logger/log.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/core/categories/infrastructure.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(
    this._categoryLocalDatasource,
    this._logger,
  );

  final CategoryLocalDatasource _categoryLocalDatasource;
  final Log _logger;

  Category _toDomain(CategoryDbDto dto) => dto.toDomain();

  @override
  Stream<List<Category>> watchCategories(String userId) async* {
    yield* _categoryLocalDatasource.watch(userId).asyncMap(
          (dtos) => dtos.map(_toDomain).toList(),
        );
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _categoryLocalDatasource.delete(id);
  }

  @override
  Future<Either<CategoryFailure, Unit>> createCategory(CreateCategoryDto dto) async {
    try {
      await _categoryLocalDatasource.upsert(dto.toCompanion());
      return right(unit);
    } catch (e, s) {
      _logger.e('Error creating category', e, s);

      return left(const CategoryFailure.unexpected());
    }
  }

  @override
  Future<void> updateCategory(String id, CreateCategoryDto dto) async {
    final companion = dto.toCompanion().copyWith(id: Value(int.parse(id)));
    await _categoryLocalDatasource.upsert(companion);
  }
}
