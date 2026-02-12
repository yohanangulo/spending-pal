import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/screens/transactions/bloc/transactions_bloc.dart';
import 'package:spending_pal/src/presentation/screens/transactions/widgets/category_filter_bottom_sheet.dart';

class TransactionFiltersBottomSheet extends StatelessWidget {
  const TransactionFiltersBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    final bloc = context.read<TransactionsBloc>();

    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: const TransactionFiltersBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, state) {
        final hasExtraFilters = state.categoryFilter != null || state.startDateFilter != null;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimens.p4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.p4),
                child: Text(
                  'Filters',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: Dimens.p2),
              ListTile(
                leading: const Icon(Icons.category_outlined),
                title: const Text('Category'),
                subtitle: Text(
                  state.categoryFilterName ?? 'All categories',
                  style: TextStyle(
                    color: state.categoryFilter != null ? AppColors.primary : null,
                    fontWeight: state.categoryFilter != null ? FontWeight.w600 : null,
                  ),
                ),
                trailing: state.categoryFilter != null
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          context.read<TransactionsBloc>().add(
                            const TransactionsCategoryFilterChanged(categoryId: null),
                          );
                        },
                      )
                    : const Icon(Icons.chevron_right),
                onTap: () async {
                  final category = await CategoryFilterBottomSheet.show(
                    context,
                    selectedCategoryId: state.categoryFilter,
                  );
                  if (category != null && context.mounted) {
                    context.read<TransactionsBloc>().add(
                      TransactionsCategoryFilterChanged(
                        categoryId: category.id,
                        categoryName: category.name,
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.date_range_outlined),
                title: const Text('Date Range'),
                subtitle: Text(
                  _dateRangeLabel(state.startDateFilter, state.endDateFilter),
                  style: TextStyle(
                    color: state.startDateFilter != null ? AppColors.primary : null,
                    fontWeight: state.startDateFilter != null ? FontWeight.w600 : null,
                  ),
                ),
                trailing: state.startDateFilter != null
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          context.read<TransactionsBloc>().add(
                            const TransactionsDateRangeChanged(startDate: null, endDate: null),
                          );
                        },
                      )
                    : const Icon(Icons.chevron_right),
                onTap: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    initialDateRange: state.startDateFilter != null && state.endDateFilter != null
                        ? DateTimeRange(start: state.startDateFilter!, end: state.endDateFilter!)
                        : null,
                  );
                  if (picked != null && context.mounted) {
                    context.read<TransactionsBloc>().add(
                      TransactionsDateRangeChanged(
                        startDate: picked.start,
                        endDate: picked.end,
                      ),
                    );
                  }
                },
              ),
              if (hasExtraFilters) ...[
                const SizedBox(height: Dimens.p2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.p4),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<TransactionsBloc>().add(
                          const TransactionsFiltersReset(),
                        );
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.clear),
                      label: const Text('Reset All Filters'),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: Dimens.p4),
            ],
          ),
        );
      },
    );
  }
}

String _dateRangeLabel(DateTime? start, DateTime? end) {
  if (start == null || end == null) return 'All time';
  final formatter = DateFormat('MMM d');
  return '${formatter.format(start)} - ${formatter.format(end)}';
}
