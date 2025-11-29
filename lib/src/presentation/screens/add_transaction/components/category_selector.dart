import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/corners.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/screens/add_transaction/bloc/add_transaction_bloc.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final bloc = context.read<AddTransactionBloc>();
    final selectedCategory = context.select((AddTransactionBloc bloc) => bloc.state.category);

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: Corners.circular8),
      onTap: () async {
        final category = await context.selectCategory();

        if (category == null) return;
        // select category
        bloc.add(AddTransactionCategorySelected(category));
      },
      trailing: const Icon(Icons.arrow_forward_ios),
      tileColor: theme.inputDecorationTheme.fillColor,
      title: Row(
        children: [
          if (selectedCategory == null)
            const Icon(Icons.category, color: AppColors.primary)
          else
            CircleAvatar(
              backgroundColor: selectedCategory.color.withValues(alpha: 0.2),
              child: Icon(
                selectedCategory.icon,
                color: selectedCategory.color,
              ),
            ),
          const SizedBox(width: Dimens.p4),
          Text(
            'Categoría',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
