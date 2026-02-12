import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/transaction/application.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';

part 'recent_transactions_event.dart';
part 'recent_transactions_state.dart';

@injectable
class RecentTransactionsBloc extends Bloc<RecentTransactionsEvent, RecentTransactionsState> {
  RecentTransactionsBloc(this._watchTransactions) : super(const RecentTransactionsState()) {
    on<RecentTransactionsSubscriptionRequested>(_onSubscriptionRequested);
  }

  final WatchTransactions _watchTransactions;

  Future<void> _onSubscriptionRequested(
    RecentTransactionsSubscriptionRequested event,
    Emitter<RecentTransactionsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    await emit.forEach(
      _watchTransactions(),
      onData: (result) {
        return result.fold(
          (failure) => state.copyWith(
            isLoading: false,
            hasError: true,
          ),
          (transactions) {
            // Take only the 5 most recent transactions
            final recentTransactions = transactions.take(5).toList();
            return state.copyWith(
              isLoading: false,
              hasError: false,
              transactions: recentTransactions,
            );
          },
        );
      },
      onError: (error, stackTrace) => state.copyWith(
        isLoading: false,
        hasError: true,
      ),
    );
  }
}
