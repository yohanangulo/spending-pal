import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/transaction/application.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';
part 'transactions_bloc.freezed.dart';

@injectable
class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc(
    this._watchTransactions,
    this._deleteTransaction,
  ) : super(TransactionsState()) {
    on<TransactionsSubscriptionRequested>(_onSubscriptionRequested);
    on<TransactionsTypeFilterChanged>(_onTypeFilterChanged);
    on<TransactionsCategoryFilterChanged>(_onCategoryFilterChanged);
    on<TransactionsDateRangeChanged>(_onDateRangeChanged);
    on<TransactionsDeleteRequested>(_onDeleteRequested);
    on<TransactionsFiltersReset>(_onFiltersReset);
  }

  final WatchTransactions _watchTransactions;
  final DeleteTransaction _deleteTransaction;

  Future<void> _onSubscriptionRequested(
    TransactionsSubscriptionRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    await emit.forEach(
      _watchTransactions(
        type: state.typeFilter,
        categoryId: state.categoryFilter,
        startDate: state.startDateFilter,
        endDate: state.endDateFilter,
      ),
      onData: (result) => result.fold(
        (failure) => state.copyWith(status: TransactionsStatus.failure, errorMessage: 'Failed to load transactions'),
        (transactions) => state.copyWith(status: TransactionsStatus.success, transactions: transactions),
      ),
      onError: (error, stackTrace) => state.copyWith(
        status: TransactionsStatus.failure,
        errorMessage: 'An error occurred',
      ),
    );
  }

  Future<void> _onTypeFilterChanged(
    TransactionsTypeFilterChanged event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(
      state.copyWith(transactions: [], typeFilter: event.type, status: TransactionsStatus.initial),
    );

    add(const TransactionsSubscriptionRequested());
  }

  Future<void> _onCategoryFilterChanged(
    TransactionsCategoryFilterChanged event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(state.copyWith(
      transactions: [],
      categoryFilter: event.categoryId,
      categoryFilterName: event.categoryName,
      status: TransactionsStatus.initial,
    ));

    add(const TransactionsSubscriptionRequested());
  }

  Future<void> _onDateRangeChanged(
    TransactionsDateRangeChanged event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(
      state.copyWith(
        startDateFilter: event.startDate,
        endDateFilter: event.endDate,
        transactions: [],
        status: TransactionsStatus.initial,
      ),
    );

    add(const TransactionsSubscriptionRequested());
  }

  Future<void> _onDeleteRequested(
    TransactionsDeleteRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    final result = await _deleteTransaction(event.transactionId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TransactionsStatus.failure,
          errorMessage: 'Failed to delete transaction',
        ),
      ),
      (_) {},
    );
  }

  Future<void> _onFiltersReset(
    TransactionsFiltersReset event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(
      state.copyWith(
        typeFilter: null,
        categoryFilter: null,
        categoryFilterName: null,
        startDateFilter: null,
        endDateFilter: null,
      ),
    );

    add(const TransactionsSubscriptionRequested());
  }
}
