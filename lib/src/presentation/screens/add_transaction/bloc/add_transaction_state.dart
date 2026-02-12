part of 'add_transaction_bloc.dart';

enum AddTransactionStatus { initial, loading, success, failure }

@freezed
abstract class AddTransactionState with _$AddTransactionState {
  factory AddTransactionState({
    @Default(TransactionType.expense) TransactionType transactionType,
    Category? category,
    @Default(AddTransactionStatus.initial) AddTransactionStatus status,
    String? errorMessage,
  }) = _AddTransactionState;

  const AddTransactionState._();

  bool get hasSelectedCategory => category != null;
  bool get isLoading => status == AddTransactionStatus.loading;
  bool get isSuccess => status == AddTransactionStatus.success;
  bool get hasError => status == AddTransactionStatus.failure;
}
