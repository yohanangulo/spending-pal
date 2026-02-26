part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class DashboardRecentTransactionsSubscriptionRequested extends DashboardEvent {}

class DashboardMonthlyTotalsSubscriptionRequested extends DashboardEvent {}

class DashboardWeeklyTotalsSubscriptionRequested extends DashboardEvent {}
