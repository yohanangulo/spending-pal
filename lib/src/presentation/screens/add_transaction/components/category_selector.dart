import 'package:flutter/material.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/corners.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    this.onCategorySelected,
    super.key,
  });

  final ValueChanged<Category>? onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: Corners.circular8),
      onTap: () async {
        final category = await context.selectCategory();
        if (category == null) return;
        onCategorySelected?.call(category);
      },
      trailing: const Icon(Icons.arrow_forward_ios),
      tileColor: theme.inputDecorationTheme.fillColor,
      title: Row(
        children: [
          const Icon(
            Icons.category,
            color: AppColors.primary,
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
