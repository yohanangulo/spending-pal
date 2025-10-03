import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/config/database/app_database.dart';
import 'package:spending_pal/src/core/categories/domain.dart';

@lazySingleton
class CategoryLocalDatasource {
  CategoryLocalDatasource(
    this._db,
    this._firebaseAuth,
  );

  final AppDatabase _db;
  final FirebaseAuth _firebaseAuth;

  $CategoriesTableTable get _table => _db.categoriesTable;

  String get userId => _firebaseAuth.currentUser!.uid;

  CategoriesTableCompanion _toCompanion(Category category) {
    return CategoriesTableCompanion.insert(
      id: category.id,
      userId: userId,
      name: category.name,
      icon: category.icon.codePoint,
      color: category.color.toARGB32(),
    );
  }

  Stream<List<Category>> watchAll() {
    final q = _table.select()
      ..where((t) => t.userId.equals(userId))
      ..orderBy([(t) => OrderingTerm(expression: t.name)]);

    return q.watch();
  }

  Future<Category> findOneById(String id) async {
    final q = _table.select()..where((t) => t.id.equals(id));
    return q.getSingle();
  }

  Future<void> upsertAll(List<Category> categories) async {
    if (categories.isEmpty) return;

    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(_table, categories.map(_toCompanion).toList());
    });
  }

  Future<void> upsert(Category category) async {
    await _table.insertOnConflictUpdate(_toCompanion(category));
  }

  Future<Category> insert(Category category) async {
    return _table.insertReturning(_toCompanion(category));
  }

  Future<void> delete(String id) async {
    await _table.deleteWhere((t) => t.id.equals(id));
  }
}
