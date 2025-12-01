import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';

@injectable
class GetTransactionById {
  const GetTransactionById(this._repository);

  final TransactionRepository _repository;

  Future<Either<TransactionFailure, Transaction>> call(String id) {
    return _repository.getTransactionById(id);
  }
}
