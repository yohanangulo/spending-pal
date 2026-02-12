import 'package:flutter/material.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/screens/add_transaction/components/category_selector.dart';

class CategorySelectorFormField extends StatelessWidget {
  const CategorySelectorFormField({
    required this.validator,
    super.key,
  });

  final FormFieldValidator<Category> validator;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return FormField<Category>(
      validator: validator,
      builder: (formState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategorySelector(onCategorySelected: formState.didChange),
            const SizedBox(height: Dimens.p1),
            if (formState.hasError)
              Padding(
                padding: const EdgeInsets.only(left: Dimens.p6),
                child: Text(
                  formState.errorText ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                ),
              ),
          ],
        );
      },
    );
  }
}
