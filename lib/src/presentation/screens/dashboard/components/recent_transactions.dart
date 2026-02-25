import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/config/router/router.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/screens/dashboard/bloc/dashboard_bloc.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: TextStyle(
                color: context.theme.colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ).fadeInLeft(
              from: 20,
              delay: const Duration(milliseconds: 800),
              duration: const Duration(milliseconds: 300),
            ),
            TextButton(
              onPressed: () {
                context.go(Routes.expenses);
              },
              child: const Text(
                'View all',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimens.p4),
        BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(Dimens.p8),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.p8),
                  child: Text(
                    'Failed to load recent transactions',
                    style: TextStyle(
                      color: context.theme.colorScheme.error,
                    ),
                  ),
                ),
              );
            }

            if (state.recentTransactions.isEmpty) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(Dimens.p4),
                  border: Border.all(
                    color: context.theme.dividerColor,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.p8),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 48,
                          color: context.theme.colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: Dimens.p4),
                        Text(
                          'No transactions yet',
                          style: TextStyle(
                            color: context.theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return DecoratedBox(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(Dimens.p4),
                border: Border.all(
                  color: context.theme.dividerColor,
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.theme.colorScheme.onSurface.withValues(alpha: 0.04),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: state.recentTransactions
                    .asMap()
                    .entries
                    .map(
                      (entry) => [
                        _TransactionItem(transaction: entry.value),
                        if (entry.key < state.recentTransactions.length - 1) const _Divider(),
                      ],
                    )
                    .expand((element) => element)
                    .toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: context.theme.dividerColor,
      height: 1,
      indent: Dimens.p12,
      endIndent: Dimens.p4,
    );
  }
}

class _TransactionItem extends StatelessWidget {
  const _TransactionItem({required this.transaction});

  final Transaction transaction;

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDay = DateTime(date.year, date.month, date.day);

    if (transactionDay == today) {
      return 'Today';
    } else if (transactionDay == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM dd').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? Colors.green : Colors.red;
    final amountPrefix = isIncome ? '+' : '-';
    final formattedAmount = NumberFormat.currency(symbol: r'$').format(transaction.amount);

    return Padding(
      padding: const EdgeInsets.all(Dimens.p4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(Dimens.p3),
            decoration: BoxDecoration(
              color: transaction.category.color.toColor().withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(Dimens.p3),
            ),
            child: Icon(
              transaction.category.icon.toIconData(),
              color: transaction.category.color.toColor(),
              size: 20,
            ),
          ),
          const SizedBox(width: Dimens.p4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: TextStyle(
                    color: context.theme.colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  transaction.category.name,
                  style: TextStyle(
                    color: context.theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$amountPrefix$formattedAmount',
                style: TextStyle(
                  color: amountColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _formatDate(transaction.date),
                style: TextStyle(
                  color: context.theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
