part of 'add_transaction_bloc.dart';

@freezed
abstract class AddTransactionEvent with _$AddTransactionEvent {
  factory AddTransactionEvent.categorySelected(Category category) = AddTransactionCategorySelected;

  factory AddTransactionEvent.typeChanged(TransactionType type) = AddTransactionTypeChanged;

  factory AddTransactionEvent.saveRequested({
    required String userId,
    required double amount,
    required String description,
    DateTime? date,
  }) = AddTransactionSaveRequested;
}
