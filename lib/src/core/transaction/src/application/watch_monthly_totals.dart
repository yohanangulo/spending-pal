import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';

@injectable
class WatchMonthlyTotals {
  const WatchMonthlyTotals(this._repository);

  final TransactionRepository _repository;

  Stream<Either<TransactionFailure, Map<TransactionType, double>>> call({
    required DateTime month,
  }) {
    return _repository.watchMonthlyTotals(month: month);
  }
}
