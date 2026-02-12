import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/corners.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/screens/add_transaction/bloc/add_transaction_bloc.dart';

class AddTransactionTabBar extends StatelessWidget {
  const AddTransactionTabBar({super.key});

  Widget buildTab(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Dimens.p3),
    child: Text(text),
  );

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return DefaultTabController(
      length: 2,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 200),
        child: Container(
          padding: const EdgeInsets.all(Dimens.p1),
          decoration: BoxDecoration(
            color: theme.inputDecorationTheme.fillColor,
            borderRadius: Corners.circularFull,
          ),
          child: TabBar.secondary(
            dividerColor: Colors.transparent,
            labelColor: theme.brightness.when(
              dark: () => Colors.black,
              light: () => Colors.white,
            ),
            indicator: BoxDecoration(
              color: AppColors.primary,
              borderRadius: Corners.circularFull,
            ),
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            onTap: (index) {
              final type = index == 0 ? TransactionType.expense : TransactionType.income;
              context.read<AddTransactionBloc>().add(AddTransactionTypeChanged(type));
            },
            tabs: ['Gasto', 'Ingreso'].map(buildTab).toList(),
          ),
        ),
      ),
    );
  }
}
