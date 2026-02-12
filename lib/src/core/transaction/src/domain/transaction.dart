import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spending_pal/src/core/categories/domain.dart';

part 'transaction.freezed.dart';

enum TransactionType { income, expense }

@freezed
abstract class Transaction with _$Transaction {
  factory Transaction({
    required String id,
    required String userId,
    required double amount,
    required String description,
    required String categoryId,
    required Category category,
    required DateTime date,
    required TransactionType type,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Transaction;

  const Transaction._();
}
