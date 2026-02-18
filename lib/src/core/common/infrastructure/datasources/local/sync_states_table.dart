import 'package:drift/drift.dart';

class SyncStates extends Table {
  late final id = integer().autoIncrement()();
  late final entity = text().unique()();
  late final lastSyncAt = dateTime().nullable()();

  @override
  String? get tableName => 'sync_states';
}
