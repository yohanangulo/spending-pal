import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';

@injectable
class GetMonthlyTotals {
  const GetMonthlyTotals(this._repository);

  final TransactionRepository _repository;

  Future<Either<TransactionFailure, Map<TransactionType, double>>> call({
    required DateTime month,
  }) {
    return _repository.getMonthlyTotals(month: month);
  }
}
