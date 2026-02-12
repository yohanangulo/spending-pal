import 'package:spending_pal/src/config/database/app_database.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/core/categories/infrastructure.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';
import 'package:spending_pal/src/core/transaction/src/infrastructure/datasources/local/transactions_table.dart';

class TransactionMapper {
  static Transaction toDomain(TransactionModel transactionModel, CategoryModel categoryModel) {
    return Transaction(
      id: transactionModel.id,
      userId: transactionModel.userId,
      amount: transactionModel.amount,
      description: transactionModel.description,
      categoryId: transactionModel.categoryId,
      category: CategoryMapper.toDomain(categoryModel),
      date: transactionModel.date,
      type: transactionModel.type.toDomain(),
      createdAt: transactionModel.createdAt,
      updatedAt: transactionModel.updatedAt,
    );
  }

  static TransactionModel toModel(
    Transaction transaction, {
    bool isDeleted = false,
    SyncStatus syncStatus = SyncStatus.pending,
  }) {
    return TransactionModel(
      id: transaction.id,
      userId: transaction.userId,
      amount: transaction.amount,
      description: transaction.description,
      categoryId: transaction.categoryId,
      date: transaction.date,
      type: TransactionTypeDb.fromDomain(transaction.type),
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
      isDeleted: isDeleted,
      syncStatus: syncStatus.index,
    );
  }
}
