import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
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
    this._watchDateRangeTotals,
  ) : super(const DashboardState()) {
    on<DashboardRecentTransactionsSubscriptionRequested>(_onRecentTransactionsRequested, transformer: restartable());
    on<DashboardMonthlyTotalsSubscriptionRequested>(_onMonthlyTotalsRequested, transformer: restartable());
    on<DashboardWeeklyTotalsSubscriptionRequested>(_onWeeklyTotalsRequested, transformer: restartable());
  }

  final WatchTransactions _watchTransactions;
  final WatchMonthlyTotals _watchMonthlyTotals;
  final WatchDateRangeTotals _watchDateRangeTotals;

  Future<void> _onRecentTransactionsRequested(
    DashboardRecentTransactionsSubscriptionRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

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

  Future<void> _onMonthlyTotalsRequested(
    DashboardMonthlyTotalsSubscriptionRequested event,
    Emitter<DashboardState> emit,
  ) async {
    final now = DateTime.now();

    await emit.forEach(
      _watchMonthlyTotals(month: now),
      onData: (result) {
        return result.fold(
          (failure) => state.copyWith(hasError: true),
          (totals) => state.copyWith(
            totalIncome: totals[TransactionType.income] ?? 0.0,
            totalExpense: totals[TransactionType.expense] ?? 0.0,
            totalsReady: true,
          ),
        );
      },
      onError: (error, stackTrace) => state.copyWith(hasError: true),
    );
  }

  Future<void> _onWeeklyTotalsRequested(
    DashboardWeeklyTotalsSubscriptionRequested event,
    Emitter<DashboardState> emit,
  ) async {
    final now = DateTime.now();
    final monday = DateTime(now.year, now.month, now.day - (now.weekday - 1));
    final sunday = DateTime(now.year, now.month, now.day + (7 - now.weekday));

    await emit.forEach(
      _watchDateRangeTotals(startDate: monday, endDate: sunday),
      onData: (result) {
        return result.fold(
          (failure) => state.copyWith(hasError: true),
          (totals) => state.copyWith(
            weeklyTotals: totals,
            weeklyTotalsReady: true,
          ),
        );
      },
      onError: (error, stackTrace) => state.copyWith(hasError: true),
    );
  }
}
