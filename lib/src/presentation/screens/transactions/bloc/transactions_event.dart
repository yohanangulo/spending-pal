part of 'transactions_bloc.dart';

sealed class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object?> get props => [];
}

/// Subscribes to real-time transaction updates
class TransactionsSubscriptionRequested extends TransactionsEvent {
  const TransactionsSubscriptionRequested();
}

/// Changes the transaction type filter
class TransactionsTypeFilterChanged extends TransactionsEvent {
  const TransactionsTypeFilterChanged({required this.type});

  final TransactionType? type; // null = all types

  @override
  List<Object?> get props => [type];
}

/// Changes the category filter
class TransactionsCategoryFilterChanged extends TransactionsEvent {
  const TransactionsCategoryFilterChanged({
    required this.categoryId,
    this.categoryName,
  });

  final String? categoryId; // null = all categories
  final String? categoryName;

  @override
  List<Object?> get props => [categoryId, categoryName];
}

/// Changes the date range filter
class TransactionsDateRangeChanged extends TransactionsEvent {
  const TransactionsDateRangeChanged({
    required this.startDate,
    required this.endDate,
  });

  final DateTime? startDate;
  final DateTime? endDate;

  @override
  List<Object?> get props => [startDate, endDate];
}

/// Deletes a transaction
class TransactionsDeleteRequested extends TransactionsEvent {
  const TransactionsDeleteRequested({required this.transactionId});

  final String transactionId;

  @override
  List<Object> get props => [transactionId];
}

/// Resets all filters
class TransactionsFiltersReset extends TransactionsEvent {
  const TransactionsFiltersReset();
}
