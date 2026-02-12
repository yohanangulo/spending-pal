import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/config/debug/logger/log.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/core/categories/infrastructure.dart';
import 'package:spending_pal/src/core/common/common.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';
import 'package:spending_pal/src/core/transaction/infrastructure.dart';
import 'package:spending_pal/src/core/transaction/src/infrastructure/datasources/local/transactions_table.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository, Syncable {
  const TransactionRepositoryImpl(
    this._localDatasource,
    this._remoteDatasource,
    this._categoryLocalDatasource,
    this._logger,
  );

  final TransactionLocalDatasource _localDatasource;
  final TransactionRemoteDatasource _remoteDatasource;
  final CategoryLocalDatasource _categoryLocalDatasource;
  final Log _logger;

  @override
  Future<Either<TransactionFailure, Unit>> addTransaction(Transaction transaction) async {
    try {
      await _localDatasource.insert(TransactionMapper.toModel(transaction));
      await _remoteDatasource.create(TransactionDto.fromDomain(transaction));

      // Mark as synced
      await _localDatasource.markAsSynced(transaction.id);

      return right(unit);
    } catch (e, s) {
      _logger.e('Error adding transaction', e, s);
      return left(TransactionFailure.unexpected());
    }
  }

  @override
  Future<Either<TransactionFailure, Unit>> updateTransaction(Transaction transaction) async {
    try {
      await _localDatasource.update(TransactionMapper.toModel(transaction));
      await _remoteDatasource.update(TransactionDto.fromDomain(transaction));

      await _localDatasource.markAsSynced(transaction.id);

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
      await _remoteDatasource.delete(id);

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
  void sync() {}
}
