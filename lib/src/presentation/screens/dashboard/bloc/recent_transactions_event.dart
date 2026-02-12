part of 'recent_transactions_bloc.dart';

sealed class RecentTransactionsEvent extends Equatable {
  const RecentTransactionsEvent();

  @override
  List<Object> get props => [];
}

class RecentTransactionsSubscriptionRequested extends RecentTransactionsEvent {
  const RecentTransactionsSubscriptionRequested();
}
