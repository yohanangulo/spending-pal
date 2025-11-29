import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';

part 'add_transaction_event.dart';
part 'add_transaction_state.dart';
part 'add_transaction_bloc.freezed.dart';

@injectable
class AddTransactionBloc extends Bloc<AddTransactionEvent, AddTransactionState> {
  AddTransactionBloc() : super(AddTransactionState()) {
    on<AddTransactionCategorySelected>(_onCategorySelectd);
  }

  void _onCategorySelectd(
    AddTransactionCategorySelected event,
    Emitter<AddTransactionState> emit,
  ) => emit(state.copyWith(category: event.category));
}
