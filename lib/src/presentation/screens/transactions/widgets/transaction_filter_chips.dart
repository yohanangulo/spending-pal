import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/screens/transactions/bloc/transactions_bloc.dart';
import 'package:spending_pal/src/presentation/screens/transactions/widgets/transaction_filters_bottom_sheet.dart';

class TransactionFilterChips extends StatelessWidget {
  const TransactionFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, state) {
        final hasExtraFilters = state.categoryFilter != null || state.startDateFilter != null;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: Dimens.p4),
          child: Row(
            children: [
              _FilterChip(
                label: 'All',
                isSelected: state.typeFilter == null,
                onTap: () {
                  context.read<TransactionsBloc>().add(
                    const TransactionsTypeFilterChanged(type: null),
                  );
                },
              ),
              const SizedBox(width: Dimens.p2),
              _FilterChip(
                label: 'Income',
                isSelected: state.typeFilter == TransactionType.income,
                onTap: () {
                  context.read<TransactionsBloc>().add(
                    const TransactionsTypeFilterChanged(
                      type: TransactionType.income,
                    ),
                  );
                },
              ),
              const SizedBox(width: Dimens.p2),
              _FilterChip(
                label: 'Expense',
                isSelected: state.typeFilter == TransactionType.expense,
                onTap: () {
                  context.read<TransactionsBloc>().add(
                    const TransactionsTypeFilterChanged(
                      type: TransactionType.expense,
                    ),
                  );
                },
              ),
              const SizedBox(width: Dimens.p2),
              IconButton(
                icon: Badge(
                  isLabelVisible: hasExtraFilters,
                  smallSize: 8,
                  child: Icon(
                    Icons.tune,
                    size: 20,
                    color: hasExtraFilters ? AppColors.primary : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                onPressed: () {
                  TransactionFiltersBottomSheet.show(context);
                },
              ),
              if (state.hasActiveFilters) ...[
                IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    context.read<TransactionsBloc>().add(
                      const TransactionsFiltersReset(),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : Theme.of(context).colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}
