import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';

@injectable
class UpdateTransaction {
  const UpdateTransaction(this._repository);

  final TransactionRepository _repository;

  Future<Either<TransactionFailure, Unit>> call({
    required String id,
    required String userId,
    required double amount,
    required String description,
    required String categoryId,
    required Category category,
    required DateTime date,
    required TransactionType type,
    required DateTime createdAt,
  }) async {
    final transaction = Transaction(
      id: id,
      userId: userId,
      amount: amount,
      description: description,
      categoryId: categoryId,
      category: category,
      date: date,
      type: type,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );

    return _repository.updateTransaction(transaction);
  }
}
