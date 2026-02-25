part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class DashboardSubscriptionRequested extends DashboardEvent {
  const DashboardSubscriptionRequested();
}

class _DashboardTotalsUpdated extends DashboardEvent {
  const _DashboardTotalsUpdated({
    required this.totalIncome,
    required this.totalExpense,
  });

  final double totalIncome;
  final double totalExpense;

  @override
  List<Object?> get props => [totalIncome, totalExpense];
}

class _DashboardTotalsError extends DashboardEvent {
  const _DashboardTotalsError();
}
