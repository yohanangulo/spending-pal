import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';
import 'package:uuid/uuid.dart';

@injectable
class AddTransaction {
  const AddTransaction(
    this._repository,
    this._uuid,
  );

  final TransactionRepository _repository;
  final Uuid _uuid;

  Future<Either<TransactionFailure, Unit>> call({
    required String userId,
    required double amount,
    required String description,
    required String categoryId,
    required Category category,
    required DateTime date,
    required TransactionType type,
  }) async {
    final now = DateTime.now();

    final transaction = Transaction(
      id: _uuid.v4(),
      userId: userId,
      amount: amount,
      description: description,
      categoryId: categoryId,
      category: category,
      date: date,
      type: type,
      createdAt: now,
      updatedAt: now,
    );

    return _repository.addTransaction(transaction);
  }
}
