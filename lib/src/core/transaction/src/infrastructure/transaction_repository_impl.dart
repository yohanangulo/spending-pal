import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/config/debug/logger/log.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';
import 'package:spending_pal/src/core/transaction/infrastructure.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl(
    this._transactionLocalDatasource,
    this._transactionRemoteDatasource,
    this._logger,
  );

  final TransactionLocalDatasource _transactionLocalDatasource;
  final TransactionRemoteDatasource _transactionRemoteDatasource;
  final Log _logger;

  @override
  Future<Either<TransactionFailure, Unit>> addTransaction(Transaction transaction) async {
    try {
      // await _transactionLocalDatasource.insert(transaction);
      // await _transactionRemoteDatasource.addTransaction(transaction);
      return right(unit);
    } catch (e, s) {
      _logger.e('Error adding transaction', e, s);

      return left(TransactionFailure.unexpected());
    }
  }
}
