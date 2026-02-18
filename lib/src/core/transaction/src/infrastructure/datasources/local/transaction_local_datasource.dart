import 'package:spending_pal/src/config/database/app_database.dart';
import 'package:spending_pal/src/core/transaction/infrastructure.dart';
import 'package:spending_pal/src/core/transaction/src/infrastructure/datasources/local/transactions_table.dart';

abstract class TransactionLocalDatasource {
  Future<void> insert(TransactionModel transaction);

  Future<void> update(TransactionModel transaction);

  Future<void> delete(String id);

  Future<TransactionModel?> findById(String id);

  Stream<List<TransactionWithCategoryModel>> watchAll({
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionTypeDb? type,
  });

  Future<List<TransactionModel>> getAll({
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionTypeDb? type,
  });

  Future<double> getTotalByCategory({
    required String categoryId,
    DateTime? startDate,
    DateTime? endDate,
  });
  Stream<List<TransactionModel>> watchPendingSync();

  Future<void> markAsSynced(String id);

  Future<TransactionModel?> findByIdForSync(String id);

  Future<List<TransactionModel>> getPendingSync();

  Future<DateTime?> getLastUpdatedAt();

  Future<void> upsert(TransactionModel transaction);

  Future<void> clearSyncedDeletes();
}
