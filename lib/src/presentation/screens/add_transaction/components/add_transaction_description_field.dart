import 'package:flutter/material.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/presentation/common/resources/decorations.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';

class AddTransactionDescriptionField extends StatelessWidget {
  const AddTransactionDescriptionField({
    required this.controller,
    this.validator,
    super.key,
  });

  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: Decorations.inputDecoration.copyWith(
        hintText: 'Descripción de la transacción',
        contentPadding: const EdgeInsets.all(Dimens.p4),
        hintStyle: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.outline,
        ),
      ),
      style: theme.textTheme.titleMedium,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
    );
  }
}
