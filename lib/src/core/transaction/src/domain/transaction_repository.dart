import 'package:dartz/dartz.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';

abstract class TransactionRepository {
  // Create
  Future<Either<TransactionFailure, Unit>> addTransaction(Transaction transaction);

  // Read
  Stream<Either<TransactionFailure, List<Transaction>>> watchTransactions({
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
  });

  Future<Either<TransactionFailure, Transaction>> getTransactionById(String id);

  // Update
  Future<Either<TransactionFailure, Unit>> updateTransaction(Transaction transaction);

  // Delete
  Future<Either<TransactionFailure, Unit>> deleteTransaction(String id);

  // Stats
  Future<Either<TransactionFailure, double>> getTotalByCategory({
    required String categoryId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Either<TransactionFailure, Map<TransactionType, double>>> getMonthlyTotals({
    required DateTime month,
  });
}
