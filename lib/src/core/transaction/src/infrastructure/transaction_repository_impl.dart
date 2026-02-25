import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/config/common/conflict_resolver.dart';
import 'package:spending_pal/src/config/connectivity/connectivity_service.dart';
import 'package:spending_pal/src/config/debug/logger/log.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/core/categories/infrastructure.dart';
import 'package:spending_pal/src/core/common/common.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';
import 'package:spending_pal/src/core/transaction/infrastructure.dart';
import 'package:spending_pal/src/core/transaction/src/infrastructure/datasources/local/transactions_table.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl(
    this._localDatasource,
    this._remoteDatasource,
    this._categoryLocalDatasource,
    this._logger,
    this._connectivityService,
    this._conflictResolver,
    this._syncStatesDao,
  );

  final TransactionLocalDatasource _localDatasource;
  final TransactionRemoteDatasource _remoteDatasource;
  final CategoryLocalDatasource _categoryLocalDatasource;
  final Log _logger;
  final ConnectivityService _connectivityService;
  final ConflictResolver _conflictResolver;
  final SyncStatesDao _syncStatesDao;

  @override
  Future<Either<TransactionFailure, Unit>> addTransaction(Transaction transaction) async {
    try {
      final model = TransactionMapper.toModel(transaction);
      await _localDatasource.insert(model);

      if (!await _connectivityService.isConnected) return right(unit);

      unawaited(_upSync());

      return right(unit);
    } catch (e, s) {
      _logger.e('Error adding transaction', e, s);
      return left(TransactionFailure.unexpected());
    }
  }

  @override
  Future<Either<TransactionFailure, Unit>> updateTransaction(Transaction transaction) async {
    try {
      final model = TransactionMapper.toModel(transaction);
      await _localDatasource.upsert(model);

      if (!await _connectivityService.isConnected) return right(unit);

      unawaited(_upSync());

      return right(unit);
    } catch (e, s) {
      _logger.e('Error updating transaction', e, s);
      return left(TransactionFailure.unexpected());
    }
  }

  @override
  Future<Either<TransactionFailure, Unit>> deleteTransaction(String id) async {
    try {
      await _localDatasource.delete(id);

      if (!await _connectivityService.isConnected) return right(unit);

      unawaited(_upSync());

      return right(unit);
    } catch (e, s) {
      _logger.e('Error deleting transaction', e, s);
      return left(TransactionFailure.unexpected());
    }
  }

  @override
  Future<Either<TransactionFailure, Transaction>> getTransactionById(
    String id,
  ) async {
    try {
      final model = await _localDatasource.findById(id);

      if (model == null) {
        return left(TransactionFailure.notFound());
      }

      final category = await _categoryLocalDatasource.findOneById(model.categoryId);

      return right(TransactionMapper.toDomain(model, category ?? CategoryMapper.toModel(Category.empty())));
    } catch (e, s) {
      _logger.e('Error getting transaction by id', e, s);
      return left(TransactionFailure.unexpected());
    }
  }

  @override
  Stream<Either<TransactionFailure, List<Transaction>>> watchTransactions({
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
  }) {
    try {
      return _localDatasource
          .watchAll(
            categoryId: categoryId,
            startDate: startDate,
            endDate: endDate?.endOfDay,
            type: type == null ? null : TransactionTypeDb.fromDomain(type),
          )
          .map((models) => right(models.map((e) => e.toDomain()).toList()));
    } catch (e, s) {
      _logger.e('Error watching transactions', e, s);
      return Stream.value(left(TransactionFailure.unexpected()));
    }
  }

  @override
  Future<Either<TransactionFailure, double>> getTotalByCategory({
    required String categoryId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final total = await _localDatasource.getTotalByCategory(
        categoryId: categoryId,
        startDate: startDate,
        endDate: endDate,
      );

      return right(total);
    } catch (e, s) {
      _logger.e('Error getting total by category', e, s);
      return left(TransactionFailure.unexpected());
    }
  }

  @override
  Future<Either<TransactionFailure, Map<TransactionType, double>>> getMonthlyTotals({
    required DateTime month,
  }) async {
    try {
      final startDate = DateTime(month.year, month.month);
      final endDate = DateTime(month.year, month.month + 1, 0);

      final allTransactions = await _localDatasource.getAll(
        startDate: startDate,
        endDate: endDate,
      );

      double incomeTotal = 0;
      double expenseTotal = 0;

      for (final transaction in allTransactions) {
        if (transaction.type.toDomain() == TransactionType.income) {
          incomeTotal += transaction.amount;
        } else {
          expenseTotal += transaction.amount;
        }
      }

      return right({
        TransactionType.income: incomeTotal,
        TransactionType.expense: expenseTotal,
      });
    } catch (e, s) {
      _logger.e('Error getting monthly totals', e, s);
      return left(TransactionFailure.unexpected());
    }
  }

  @override
  Stream<Either<TransactionFailure, Map<TransactionType, double>>> watchMonthlyTotals({
    required DateTime month,
  }) {
    try {
      final startDate = DateTime(month.year, month.month);
      final endDate = DateTime(month.year, month.month + 1, 0).endOfDay;

      return _localDatasource.watchMonthlyTotals(startDate: startDate, endDate: endDate).map((totals) {
        return right({
          TransactionType.income: totals[TransactionTypeDb.income] ?? 0.0,
          TransactionType.expense: totals[TransactionTypeDb.expense] ?? 0.0,
        });
      });
    } catch (e, s) {
      _logger.e('Error watching monthly totals', e, s);
      return Stream.value(left(TransactionFailure.unexpected()));
    }
  }

  @override
  Stream<Map<String, int>> watchTransactionCountsByCategory({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _localDatasource.watchCountByCategory(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<Either<TransactionFailure, Unit>> sync() async {
    try {
      _logger.i('Syncing transactions');

      await _upSync();
      await _downSync();
      await _localDatasource.clearSyncedDeletes();

      _logger.i('Transactions synced');

      return right(unit);
    } catch (e, s) {
      _logger.e('Error syncing transactions', e, s);
      return left(TransactionFailure.unexpected());
    }
  }

  Future<void> _upSync() async {
    final pendingTransactions = await _localDatasource.getPendingSync();

    for (final pending in pendingTransactions) {
      final remote = await _remoteDatasource.getById(pending.id);

      if (remote == null) {
        await _remoteDatasource.upsert(TransactionDto.fromModel(pending));
        await _localDatasource.upsert(pending.copyWith(syncStatus: SyncStatus.synced.index));

        continue;
      }

      final resolved = _conflictResolver.resolveLatest(
        local: pending,
        remote: remote.toModel(syncStatus: SyncStatus.synced),
      );

      await resolved.fold(
        (local) async {
          await _remoteDatasource.upsert(TransactionDto.fromModel(local));
          await _localDatasource.upsert(local.copyWith(syncStatus: SyncStatus.synced.index));
        },
        (remote) async {
          await _localDatasource.upsert(remote.copyWith(syncStatus: SyncStatus.synced.index));
        },
      );
    }
  }

  Future<void> _downSync() async {
    final DateTime? lastSync = await _syncStatesDao.get<Transaction>();
    final remoteChanges = await _remoteDatasource.getUpdatedTransactions(lastSync);

    _logger.i('Found ${remoteChanges.length} transactions to downSync');

    for (final remoteItem in remoteChanges) {
      final localItem = await _localDatasource.findByIdForSync(remoteItem.id);

      if (localItem == null) {
        await _localDatasource.upsert(remoteItem.toModel(syncStatus: SyncStatus.synced));

        continue;
      }

      final resolved = _conflictResolver.resolveLatest(
        local: localItem,
        remote: remoteItem.toModel(syncStatus: SyncStatus.synced),
      );

      await resolved.fold(
        (local) async {
          await _remoteDatasource.upsert(TransactionDto.fromModel(local));
          await _localDatasource.upsert(local.copyWith(syncStatus: SyncStatus.synced.index));
        },
        (remote) async {
          await _localDatasource.upsert(remote.copyWith(syncStatus: SyncStatus.synced.index));
        },
      );
    }

    if (remoteChanges.isEmpty) return;

    final maxUpdatedDateTime = remoteChanges.map((c) => c.updatedAt).maxOrNull!;
    _logger.i('Setting last sync to $maxUpdatedDateTime $lastSync');
    await _syncStatesDao.set<Transaction>(maxUpdatedDateTime);
  }
}
