import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/screens/transactions/bloc/transactions_bloc.dart';

class FilteredEmptyState extends StatelessWidget {
  const FilteredEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.p8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_list_off,
              size: 80,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: Dimens.p6),
            Text(
              'No Transactions Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: Dimens.p3),
            Text(
              'No transactions match your current filter',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: Dimens.p6),
            OutlinedButton.icon(
              onPressed: () {
                context.read<TransactionsBloc>().add(
                  const TransactionsFiltersReset(),
                );
              },
              icon: const Icon(Icons.clear),
              label: const Text('Clear Filter'),
            ),
          ],
        ),
      ),
    );
  }
}
