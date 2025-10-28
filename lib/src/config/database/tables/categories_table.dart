import 'package:drift/drift.dart';
import 'package:spending_pal/src/core/categories/domain.dart';

@UseRowClass(Category, constructor: 'fromDb')
class CategoriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get icon => integer()();
  IntColumn get color => integer()();
  TextColumn get userId => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, name},
  ];

  @override
  String get tableName => 'categories';
}
