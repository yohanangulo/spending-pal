import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/config/database/app_database.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/core/transaction/infrastructure.dart';
import 'package:spending_pal/src/core/transaction/src/infrastructure/datasources/local/transactions_table.dart';

@LazySingleton(as: TransactionLocalDatasource)
class TransactionLocalDatasourceImpl implements TransactionLocalDatasource {
  const TransactionLocalDatasourceImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> insert(TransactionModel transaction) async {
    await _db.into(_db.transactions).insert(transaction, mode: InsertMode.replace);
  }

  @override
  Future<void> update(TransactionModel transaction) async {
    await _db.update(_db.transactions).replace(transaction);
  }

  @override
  Future<void> delete(String id) async {
    await (_db.update(_db.transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        isDeleted: const Value(true),
        syncStatus: Value(SyncStatus.pending.index),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<TransactionModel?> findById(String id) async {
    return (_db.select(
      _db.transactions,
    )..where((t) => t.id.equals(id) & t.isDeleted.equals(false))).getSingleOrNull();
  }

  @override
  Stream<List<TransactionWithCategoryModel>> watchAll({
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionTypeDb? type,
  }) {
    final categories = _db.categories;
    final transactions = _db.transactions;

    final q = _db.select(transactions).join([
      innerJoin(categories, transactions.categoryId.equalsExp(categories.id)),
    ])..where(transactions.isDeleted.equals(false));

    if (categoryId != null) {
      q.where(categories.id.equals(categoryId));
    }

    if (startDate != null) {
      q.where(transactions.date.isBiggerOrEqualValue(startDate));
    }

    if (endDate != null) {
      q.where(transactions.date.isSmallerOrEqualValue(endDate));
    }

    if (type != null) {
      q.where(transactions.type.equals(type.index));
    }

    q.orderBy([OrderingTerm.desc(transactions.date)]);

    return q.watch().map((e) {
      return e.map((e) {
        return TransactionWithCategoryModel(
          e.readTable(transactions),
          e.readTable(categories),
        );
      }).toList();
    });
  }

  @override
  Future<List<TransactionModel>> getAll({
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionTypeDb? type,
  }) {
    final query = _buildQuery(
      categoryId: categoryId,
      startDate: startDate,
      endDate: endDate,
      type: type,
    );
    return query.get();
  }

  SimpleSelectStatement<$TransactionsTable, TransactionModel> _buildQuery({
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionTypeDb? type,
  }) {
    final query = _db.select(_db.transactions)..where((t) => t.isDeleted.equals(false));

    if (categoryId != null) {
      query.where((t) => t.categoryId.equals(categoryId));
    }

    if (startDate != null) {
      query.where((t) => t.date.isBiggerOrEqualValue(startDate));
    }

    if (endDate != null) {
      query.where((t) => t.date.isSmallerOrEqualValue(endDate));
    }

    if (type != null) {
      query.where((t) => t.type.equals(type.index));
    }

    query.orderBy([
      (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
    ]);

    return query;
  }

  @override
  Future<double> getTotalByCategory({
    required String categoryId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final query = _db.select(_db.transactions)
      ..where((t) => t.categoryId.equals(categoryId) & t.isDeleted.equals(false));

    if (startDate != null) {
      query.where((t) => t.date.isBiggerOrEqualValue(startDate));
    }

    if (endDate != null) {
      query.where((t) => t.date.isSmallerOrEqualValue(endDate));
    }

    final results = await query.get();
    return results.fold<double>(0, (sum, t) => sum + t.amount);
  }

  @override
  Stream<List<TransactionModel>> watchPendingSync() {
    return (_db.select(
      _db.transactions,
    )..where((t) => t.syncStatus.equals(SyncStatus.pending.index) & t.isDeleted.equals(false))).watch();
  }

  @override
  Future<void> markAsSynced(String id) async {
    await (_db.update(_db.transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        syncStatus: Value(SyncStatus.synced.index),
      ),
    );
  }

  @override
  Future<TransactionModel?> findByIdForSync(String id) async {
    return (_db.select(_db.transactions)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  @override
  Future<List<TransactionModel>> getPendingSync() {
    final q = _db.select(_db.transactions)
      ..where(
        (t) => t.syncStatus.equals(SyncStatus.pending.index) | t.syncStatus.equals(SyncStatus.error.index),
      );

    return q.get();
  }

  @override
  Future<DateTime?> getLastUpdatedAt() async {
    final q = _db.select(_db.transactions)
      ..orderBy([(t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc)])
      ..limit(1);

    final transactions = await q.get();

    if (transactions.isEmpty) return null;

    return transactions.first.updatedAt;
  }

  @override
  Future<void> upsert(TransactionModel transaction) async {
    await _db.into(_db.transactions).insertOnConflictUpdate(transaction);
  }

  @override
  Future<void> clearSyncedDeletes() {
    final q = _db.delete(_db.transactions)
      ..where((t) => t.isDeleted.equals(true))
      ..where((t) => t.syncStatus.equals(SyncStatus.synced.index));

    return q.go();
  }

  @override
  Stream<Map<String, int>> watchCountByCategory({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final categoryId = _db.transactions.categoryId;
    final count = _db.transactions.id.count();

    final query = _db.selectOnly(_db.transactions)
      ..addColumns([categoryId, count])
      ..where(_db.transactions.isDeleted.equals(false))
      ..where(_db.transactions.date.isBiggerOrEqualValue(startDate))
      ..where(_db.transactions.date.isSmallerOrEqualValue(endDate))
      ..groupBy([categoryId]);

    return query.watch().map((rows) {
      return {
        for (final row in rows) row.read(categoryId)!: row.read(count)!,
      };
    });
  }
}
