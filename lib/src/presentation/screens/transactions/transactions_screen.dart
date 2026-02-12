import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/config/service_locator/service_locator.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/common/widgets/loading_body.dart';
import 'package:spending_pal/src/presentation/screens/transactions/bloc/transactions_bloc.dart';
import 'package:spending_pal/src/presentation/screens/transactions/components/transactions_body.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TransactionsBloc>()..add(const TransactionsSubscriptionRequested()),
      child: const _TransactionsView(),
    );
  }
}

class _TransactionsView extends StatelessWidget {
  const _TransactionsView();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      body: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) {
          switch (state.status) {
            case TransactionsStatus.initial:
              return const LoadingBody();
            case TransactionsStatus.failure:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: Dimens.p4),
                    Text(
                      state.errorMessage ?? 'Failed to load transactions',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: Dimens.p4),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TransactionsBloc>().add(const TransactionsSubscriptionRequested());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            case TransactionsStatus.success:
              return TransactionsBody(
                transactions: state.transactions,
                hasActiveFilters: state.hasActiveFilters,
                groupedTransactions: state.groupedTransactions,
              );
          }
        },
      ),
    );
  }
}
