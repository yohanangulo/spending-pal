import 'package:spending_pal/src/config/database/app_database.dart';

abstract class CategoryLocalDatasource {
  Stream<List<CategoryModel>> watchAll();

  Future<CategoryModel?> findOneById(String id);

  Future<void> upsertAll(List<CategoryModel> categories);

  Future<void> upsert(CategoryModel category);

  Future<CategoryModel> insert(CategoryModel category);

  Future<void> softDelete(String id);

  Future<void> clearSyncedDeletes();

  Future<List<CategoryModel>> getPendingSync();

  Future<DateTime?> getLastUpdatedAt();
}
