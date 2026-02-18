import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';

@injectable
class SyncTransactions {
  SyncTransactions(this._transactionRepository);

  final TransactionRepository _transactionRepository;

  Future<Either<TransactionFailure, Unit>> call() => _transactionRepository.sync();
}
