import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/config/database/app_database.dart';
import 'package:spending_pal/src/core/common/common.dart';

part 'sync_states_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [SyncStates])
class SyncStatesDao extends DatabaseAccessor<AppDatabase> with _$SyncStatesDaoMixin {
  SyncStatesDao(super.attachedDatabase);

  Future<DateTime?> get<T extends Object>() async {
    assert(const Object() is! T, 'The compiler could not infer the type. You have to provide a type');

    final entityName = T.toString();

    final q = select(syncStates)..where((t) => t.entity.equals(entityName));

    final result = await q.getSingleOrNull();

    return result?.lastSyncAt;
  }

  Future<void> set<T extends Object>(DateTime value) async {
    assert(const Object() is! T, 'The compiler could not infer the type. You have to provide a type');

    final entityName = T.toString();

    await into(syncStates).insert(
      SyncStatesCompanion.insert(entity: entityName, lastSyncAt: Value(value)),
      onConflict: DoUpdate(
        (old) => SyncStatesCompanion(lastSyncAt: Value(value)),
        target: [syncStates.entity],
      ),
    );
  }
}
