part of 'add_transaction_bloc.dart';

@freezed
class AddTransactionEvent with _$AddTransactionEvent {
  factory AddTransactionEvent.started() = _Started;
}
