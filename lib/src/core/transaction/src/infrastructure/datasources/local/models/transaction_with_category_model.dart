import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spending_pal/src/config/database/app_database.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';
import 'package:spending_pal/src/core/transaction/infrastructure.dart';

part 'transaction_with_category_model.freezed.dart';

@freezed
abstract class TransactionWithCategoryModel with _$TransactionWithCategoryModel {
  const factory TransactionWithCategoryModel(
    final TransactionModel transaction,
    final CategoryModel category,
  ) = _TransactionWithCategoryModel;

  const TransactionWithCategoryModel._();

  Transaction toDomain() => TransactionMapper.toDomain(transaction, category);
}
