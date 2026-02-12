part of 'transactions_bloc.dart';

enum TransactionsStatus { initial, success, failure }

@freezed
abstract class TransactionsState with _$TransactionsState {
  factory TransactionsState({
    @Default([]) List<Transaction> transactions,
    @Default(TransactionsStatus.initial) TransactionsStatus status,
    TransactionType? typeFilter,
    String? categoryFilter,
    String? categoryFilterName,
    DateTime? startDateFilter,
    DateTime? endDateFilter,
    String? errorMessage,
  }) = _TransactionsState;

  const TransactionsState._();

  /// Check if any filters are active
  bool get hasActiveFilters =>
      typeFilter != null || categoryFilter != null || startDateFilter != null || endDateFilter != null;

  /// Group transactions by date for display
  Map<String, List<Transaction>> get groupedTransactions {
    final Map<String, List<Transaction>> grouped = {};
    final now = DateTime.now();

    for (final transaction in transactions) {
      String key;
      final transactionDate = transaction.date;

      if (_isSameDay(transactionDate, now)) {
        key = 'Today';
      } else if (_isSameDay(transactionDate, now.subtract(const Duration(days: 1)))) {
        key = 'Yesterday';
      } else if (transactionDate.isAfter(now.subtract(const Duration(days: 7)))) {
        key = 'This Week';
      } else if (transactionDate.isAfter(now.subtract(const Duration(days: 30)))) {
        key = 'This Month';
      } else {
        key = '${_monthName(transactionDate.month)} ${transactionDate.year}';
      }

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(transaction);
    }

    return grouped;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
