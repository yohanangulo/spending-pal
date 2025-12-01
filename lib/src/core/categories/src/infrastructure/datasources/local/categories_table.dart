import 'package:drift/drift.dart';
import 'package:spending_pal/src/config/database/mixins.dart';
import 'package:spending_pal/src/core/common/common.dart';

@DataClassName('CategoryModel', implementing: [HasUpdatedAt])
class Categories extends Table with Timestamps, SoftDelete, SyncStatus {
  late final id = text()();
  late final name = text()();
  late final icon = integer()();
  late final color = integer()();
  late final userId = text()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, name},
  ];
}
