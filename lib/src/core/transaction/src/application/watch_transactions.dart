import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';

@injectable
class WatchTransactions {
  const WatchTransactions(this._transactionRepository);

  final TransactionRepository _transactionRepository;

  Stream<Either<TransactionFailure, List<Transaction>>> call({
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
  }) {
    return _transactionRepository.watchTransactions(
      categoryId: categoryId,
      startDate: startDate,
      endDate: endDate,
      type: type,
    );
  }
}
