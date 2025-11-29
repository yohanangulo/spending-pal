part of 'add_transaction_bloc.dart';

@freezed
abstract class AddTransactionEvent with _$AddTransactionEvent {
  factory AddTransactionEvent.categorySelected(Category category) = AddTransactionCategorySelected;
}
