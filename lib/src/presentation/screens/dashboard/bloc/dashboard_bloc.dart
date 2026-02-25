import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/transaction/application.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(
    this._watchTransactions,
    this._watchMonthlyTotals,
  ) : super(const DashboardState()) {
    on<DashboardSubscriptionRequested>(_onSubscriptionRequested);
    on<_DashboardTotalsUpdated>(_onTotalsUpdated);
    on<_DashboardTotalsError>(_onTotalsError);
  }

  final WatchTransactions _watchTransactions;
  final WatchMonthlyTotals _watchMonthlyTotals;

  StreamSubscription<dynamic>? _totalsSubscription;

  Future<void> _onSubscriptionRequested(
    DashboardSubscriptionRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final now = DateTime.now();

    _subscribeToMonthlyTotals(now);

    await emit.forEach(
      _watchTransactions(),
      onData: (result) {
        return result.fold(
          (failure) => state.copyWith(isLoading: false, hasError: true),
          (transactions) {
            final recentTransactions = transactions.take(5).toList();
            return state.copyWith(
              isLoading: false,
              hasError: false,
              recentTransactions: recentTransactions,
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

  void _subscribeToMonthlyTotals(DateTime now) {
    _totalsSubscription = _watchMonthlyTotals(month: now).listen(
      (result) {
        result.fold(
          (failure) => add(const _DashboardTotalsError()),
          (totals) => add(_DashboardTotalsUpdated(
            totalIncome: totals[TransactionType.income] ?? 0.0,
            totalExpense: totals[TransactionType.expense] ?? 0.0,
          )),
        );
      },
    );
  }

  void _onTotalsUpdated(
    _DashboardTotalsUpdated event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(
      totalIncome: event.totalIncome,
      totalExpense: event.totalExpense,
    ));
  }

  void _onTotalsError(
    _DashboardTotalsError event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(hasError: true));
  }

  @override
  Future<void> close() {
    _totalsSubscription?.cancel();
    return super.close();
  }
}
