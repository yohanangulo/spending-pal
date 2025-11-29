import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/config/database/app_database.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/core/categories/infrastructure.dart';

@LazySingleton(as: CategoryLocalDatasource)
class CategoryLocalDatasourceImpl implements CategoryLocalDatasource {
  CategoryLocalDatasourceImpl(this._db, this._firebaseAuth);

  final AppDatabase _db;
  final FirebaseAuth _firebaseAuth;

  $CategoriesTable get _table => _db.categories;

  String get userId => _firebaseAuth.currentUser!.uid;

  @override
  Stream<List<CategoryModel>> watchAll() {
    final q = _table.select()
      ..where((t) => t.userId.equals(userId))
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]);

    return q.watch();
  }

  @override
  Future<CategoryModel> findOneById(String id) async {
    final q = _table.select()..where((t) => t.id.equals(id));
    return q.getSingle();
  }

  @override
  Future<void> upsertAll(List<CategoryModel> categories) async {
    if (categories.isEmpty) return;

    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(_table, categories.map((e) => e.toCompanion(true)).toList());
    });
  }

  @override
  Future<void> upsert(CategoryModel category) async {
    await _table.insertOnConflictUpdate(category.toCompanion(true));
  }

  @override
  Future<CategoryModel> insert(CategoryModel category) async {
    return _table.insertReturning(category.toCompanion(true));
  }

  @override
  Future<void> delete(String id) async {
    final q = _table.select()..where((tbl) => tbl.id.equals(id));
    final category = await q.getSingle();

    final updatedCategory = category.copyWith(isDeleted: true, syncStatus: SyncStatus.pending.index);

    await upsert(updatedCategory);
  }
}
