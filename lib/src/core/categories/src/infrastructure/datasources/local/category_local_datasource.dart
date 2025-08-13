import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/config/database/app_database.dart';

@lazySingleton
class CategoryLocalDatasource {
  CategoryLocalDatasource(
    this._db,
  );

  final AppDatabase _db;

  Future<void> createDefaultCategories(String userId) async {
    await _db.categoriesTable.insertAll([
      CategoriesTableCompanion.insert(
        name: 'Alimentación',
        icon: 0xe532,
        color: 0xff0000,
        userId: userId,
      ),
      CategoriesTableCompanion.insert(
        name: 'Transporte',
        icon: 0xe1d7,
        color: 0xff0000,
        userId: userId,
      ),
      CategoriesTableCompanion.insert(
        name: 'Entretenimiento',
        icon: 0xe5e8,
        color: 0xff0000,
        userId: userId,
      ),
    ]);
  }

  Stream<List<CategoryDbDto>> watch(String userId) {
    final q = _db.categoriesTable.select()
      ..where((t) => t.userId.equals(userId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
      ]);
    return q.watch();
  }

  Future<void> upsert(CategoriesTableCompanion category) async {
    await _db.categoriesTable.insertOnConflictUpdate(category);
  }

  Future<void> delete(String id) async {
    await _db.categoriesTable.deleteWhere((t) => t.id.equals(int.parse(id)));
  }
}
