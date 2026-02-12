part of 'recent_transactions_bloc.dart';

class RecentTransactionsState extends Equatable {
  const RecentTransactionsState({
    this.transactions = const [],
    this.isLoading = false,
    this.hasError = false,
  });

  final List<Transaction> transactions;
  final bool isLoading;
  final bool hasError;

  @override
  List<Object> get props => [transactions, isLoading, hasError];

  RecentTransactionsState copyWith({
    List<Transaction>? transactions,
    bool? isLoading,
    bool? hasError,
  }) {
    return RecentTransactionsState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }
}
