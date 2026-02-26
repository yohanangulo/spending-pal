part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  const DashboardState({
    this.totalIncome = 0,
    this.totalExpense = 0,
    this.recentTransactions = const [],
    this.weeklyTotals = const [],
    this.isLoading = false,
    this.hasError = false,
    this.totalsReady = false,
    this.weeklyTotalsReady = false,
  });

  final double totalIncome;
  final double totalExpense;
  final List<Transaction> recentTransactions;
  final List<DailyTotal> weeklyTotals;
  final bool isLoading;
  final bool hasError;
  final bool totalsReady;
  final bool weeklyTotalsReady;

  double get balance => totalIncome - totalExpense;

  @override
  List<Object> get props => [
    totalIncome,
    totalExpense,
    recentTransactions,
    weeklyTotals,
    isLoading,
    hasError,
    totalsReady,
    weeklyTotalsReady,
  ];

  DashboardState copyWith({
    double? totalIncome,
    double? totalExpense,
    List<Transaction>? recentTransactions,
    List<DailyTotal>? weeklyTotals,
    bool? isLoading,
    bool? hasError,
    bool? totalsReady,
    bool? weeklyTotalsReady,
  }) {
    return DashboardState(
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      weeklyTotals: weeklyTotals ?? this.weeklyTotals,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      totalsReady: totalsReady ?? this.totalsReady,
      weeklyTotalsReady: weeklyTotalsReady ?? this.weeklyTotalsReady,
    );
  }
}
