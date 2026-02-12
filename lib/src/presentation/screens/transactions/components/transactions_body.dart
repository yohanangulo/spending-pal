import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/screens/transactions/bloc/transactions_bloc.dart';
import 'package:spending_pal/src/presentation/screens/transactions/widgets/empty_transactions_state.dart';
import 'package:spending_pal/src/presentation/screens/transactions/widgets/filtered_empty_state.dart';
import 'package:spending_pal/src/presentation/screens/transactions/widgets/transaction_card.dart';
import 'package:spending_pal/src/presentation/screens/transactions/widgets/transaction_filter_chips.dart';

class TransactionsBody extends StatelessWidget {
  const TransactionsBody({
    required this.transactions,
    required this.hasActiveFilters,
    required this.groupedTransactions,
    super.key,
  });

  final List<Transaction> transactions;
  final bool hasActiveFilters;
  final Map<String, List<Transaction>> groupedTransactions;

  void _showDeleteDialog(
    BuildContext context,
    String transactionId,
    String description,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: Text('Are you sure you want to delete "$description"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<TransactionsBloc>().add(
                TransactionsDeleteRequested(transactionId: transactionId),
              );
              context.showSnackBar(
                const SnackBar(content: Text('Transaction deleted')),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    if (transactions.isEmpty && !hasActiveFilters) {
      return const EmptyTransactionsState();
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: theme.colorScheme.surface,
          expandedHeight: 160,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            background: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primaryContainer,
                  ],
                ),
              ),
              child: Text(
                'Transactions',
                style: context.theme.textTheme.headlineSmall,
              ),
            ),
            title: const TransactionFilterChips(),
            expandedTitleScale: 1,
          ),
        ),

        if (hasActiveFilters && groupedTransactions.isEmpty) const SliverToBoxAdapter(child: FilteredEmptyState()),

        ...groupedTransactions.entries
            .map(
              (entry) => [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.p4,
                      vertical: Dimens.p2,
                    ),
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),

                SliverList.builder(
                  itemCount: entry.value.length,
                  itemBuilder: (context, index) {
                    final transaction = entry.value[index];
                    return FadeIn(
                      key: Key(transaction.id),
                      duration: const Duration(milliseconds: 300),
                      delay: Duration(milliseconds: 50 * index),
                      child: TransactionCard(
                        transaction: transaction,
                        onDelete: () => _showDeleteDialog(
                          context,
                          transaction.id,
                          transaction.description,
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                ),
              ],
            )
            .expand((element) => element),

        const SliverToBoxAdapter(child: SizedBox(height: Dimens.p8)),
      ],
    );
  }
}
