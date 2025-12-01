import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/core/transaction/application.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';

part 'add_transaction_event.dart';
part 'add_transaction_state.dart';
part 'add_transaction_bloc.freezed.dart';

@injectable
class AddTransactionBloc extends Bloc<AddTransactionEvent, AddTransactionState> {
  AddTransactionBloc(
    this._addTransaction,
  ) : super(AddTransactionState()) {
    on<AddTransactionCategorySelected>(_onCategorySelected);
    on<AddTransactionTypeChanged>(_onTypeChanged);
    on<AddTransactionSaveRequested>(_onSaveRequested);
  }

  final AddTransaction _addTransaction;

  void _onCategorySelected(
    AddTransactionCategorySelected event,
    Emitter<AddTransactionState> emit,
  ) => emit(state.copyWith(category: event.category));

  void _onTypeChanged(
    AddTransactionTypeChanged event,
    Emitter<AddTransactionState> emit,
  ) => emit(state.copyWith(transactionType: event.type));

  Future<void> _onSaveRequested(
    AddTransactionSaveRequested event,
    Emitter<AddTransactionState> emit,
  ) async {
    if (state.category == null) {
      emit(state.copyWith(status: AddTransactionStatus.failure, errorMessage: 'Please select a category'));
      return;
    }

    emit(state.copyWith(status: AddTransactionStatus.loading));

    // Call use case (use case handles ID generation, timestamps, etc.)
    final result = await _addTransaction(
      userId: event.userId,
      amount: event.amount,
      description: event.description,
      categoryId: state.category!.id,
      category: state.category!,
      date: event.date ?? DateTime.now(),
      type: state.transactionType,
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(status: AddTransactionStatus.failure, errorMessage: 'Failed to save transaction')),
      (_) => emit(state.copyWith(status: AddTransactionStatus.success)),
    );
  }
}
