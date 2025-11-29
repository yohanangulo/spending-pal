import 'package:dartz/dartz.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';

abstract class TransactionRepository {
  Future<Either<TransactionFailure, Unit>> addTransaction(Transaction transaction);
}
