part of 'add_transaction_bloc.dart';

@freezed
abstract class AddTransactionState with _$AddTransactionState {
  factory AddTransactionState({
    @Default(TransactionType.expense) TransactionType transactionType,
    Category? category,
  }) = _AddTransactionState;

  const AddTransactionState._();

  bool get hasSelectedCategory => category != null;
}
