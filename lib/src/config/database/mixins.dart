import 'package:drift/drift.dart';

mixin Timestamps on Table {
  late final createdAt = dateTime()();
  late final updatedAt = dateTime()();
}

mixin SoftDelete on Table {
  late final isDeleted = boolean().withDefault(const Constant(false))();
}

mixin SyncStatus on Table {
  late final syncStatus = integer()();
}
