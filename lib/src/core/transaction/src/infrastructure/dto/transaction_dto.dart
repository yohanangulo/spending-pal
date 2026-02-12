import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spending_pal/src/config/database/app_database.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';
import 'package:spending_pal/src/core/transaction/src/infrastructure/datasources/local/transactions_table.dart';

part 'transaction_dto.freezed.dart';
part 'transaction_dto.g.dart';

@freezed
abstract class TransactionDto with _$TransactionDto {
  factory TransactionDto({
    required String id,
    required String userId,
    required double amount,
    required String description,
    required String categoryId,
    required DateTime date,
    required String type, // "income" or "expense" for JSON
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isDeleted,
  }) = _TransactionDto;

  const TransactionDto._();

  factory TransactionDto.fromJson(Map<String, dynamic> json) => _$TransactionDtoFromJson(json);

  // From Drift model
  factory TransactionDto.fromModel(TransactionModel model) => TransactionDto(
    id: model.id,
    userId: model.userId,
    amount: model.amount,
    description: model.description,
    categoryId: model.categoryId,
    date: model.date,
    type: model.type.name, // Convert enum to string
    createdAt: model.createdAt,
    updatedAt: model.updatedAt,
    isDeleted: model.isDeleted,
  );

  factory TransactionDto.fromDomain(Transaction transaction) => TransactionDto(
    id: transaction.id,
    userId: transaction.userId,
    amount: transaction.amount,
    description: transaction.description,
    categoryId: transaction.categoryId,
    date: transaction.date,
    type: transaction.type.name,
    createdAt: transaction.createdAt,
    updatedAt: transaction.updatedAt,
  );

  // To Drift model
  TransactionModel toModel() => TransactionModel(
    id: id,
    userId: userId,
    amount: amount,
    description: description,
    categoryId: categoryId,
    date: date,
    type: _mapStringToDbType(type),
    createdAt: createdAt,
    updatedAt: updatedAt,
    isDeleted: isDeleted,
    syncStatus: SyncStatus.pending.index,
  );

  static TransactionTypeDb _mapStringToDbType(String type) {
    return type == 'income' ? TransactionTypeDb.income : TransactionTypeDb.expense;
  }

  // From Firebase (JSON)
  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'amount': amount,
    'description': description,
    'categoryId': categoryId,
    'date': date.toIso8601String(),
    'type': type,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
