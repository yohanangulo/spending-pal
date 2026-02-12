import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';

@injectable
class DeleteTransaction {
  const DeleteTransaction(this._repository);

  final TransactionRepository _repository;

  Future<Either<TransactionFailure, Unit>> call(String id) {
    return _repository.deleteTransaction(id);
  }
}
