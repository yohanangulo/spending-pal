import 'package:drift/drift.dart';
import 'package:spending_pal/src/config/database/mixins.dart';
import 'package:spending_pal/src/core/common/common.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';

enum TransactionTypeDb {
  income,
  expense;

  TransactionType toDomain() {
    return TransactionType.values.firstWhere((element) => element.name == name);
  }

  static TransactionTypeDb fromDomain(TransactionType type) {
    return TransactionTypeDb.values.firstWhere((element) => element.name == type.name);
  }
}

@DataClassName('TransactionModel', implementing: [HasUpdatedAt])
class Transactions extends Table with Timestamps, SoftDelete, SyncStatus {
  late final id = text()();
  late final userId = text()();
  late final amount = real()();
  late final description = text()();
  late final categoryId = text()();
  late final date = dateTime()();
  late final type = intEnum<TransactionTypeDb>()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
