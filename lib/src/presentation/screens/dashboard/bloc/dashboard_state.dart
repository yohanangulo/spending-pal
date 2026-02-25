part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  const DashboardState({
    this.totalIncome = 0,
    this.totalExpense = 0,
    this.recentTransactions = const [],
    this.isLoading = false,
    this.hasError = false,
    this.totalsReady = false,
  });

  final double totalIncome;
  final double totalExpense;
  final List<Transaction> recentTransactions;
  final bool isLoading;
  final bool hasError;
  final bool totalsReady;

  double get balance => totalIncome - totalExpense;

  @override
  List<Object> get props => [
    totalIncome,
    totalExpense,
    recentTransactions,
    isLoading,
    hasError,
    totalsReady,
  ];

  DashboardState copyWith({
    double? totalIncome,
    double? totalExpense,
    List<Transaction>? recentTransactions,
    bool? isLoading,
    bool? hasError,
    bool? totalsReady,
  }) {
    return DashboardState(
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      totalsReady: totalsReady ?? this.totalsReady,
    );
  }
}
