import 'package:drift/drift.dart';

@DataClassName('CategoryDbDto')
class CategoriesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get icon => integer()();
  IntColumn get color => integer()();
  TextColumn get userId => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {userId, name}
      ];

  @override
  String get tableName => 'categories';
}
