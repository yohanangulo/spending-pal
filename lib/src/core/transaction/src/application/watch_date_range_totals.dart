import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';

@injectable
class WatchDateRangeTotals {
  const WatchDateRangeTotals(this._transactionsRepository);

  final TransactionRepository _transactionsRepository;

  Stream<Either<TransactionFailure, List<DailyTotal>>> call({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _transactionsRepository.watchTransactions(startDate: startDate, endDate: endDate).map((result) {
      return result.map((transactions) {
        final Map<DateTime, ({double income, double expense})> totals = {};

        for (DateTime d = startDate.startOfDay; !d.isAfter(endDate.startOfDay); d = d.add(const Duration(days: 1))) {
          totals[d] = (income: 0.0, expense: 0.0);
        }

        for (final tx in transactions) {
          final dayKey = tx.date.startOfDay;
          final current = totals[dayKey];
          if (current == null) continue;
          if (tx.type == TransactionType.income) {
            totals[dayKey] = (income: current.income + tx.amount, expense: current.expense);
          } else {
            totals[dayKey] = (income: current.income, expense: current.expense + tx.amount);
          }
        }

        return totals.entries
            .map((e) => DailyTotal(date: e.key, income: e.value.income, expense: e.value.expense))
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));
      });
    });
  }
}
