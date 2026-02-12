import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:spending_pal/src/presentation/common/resources/decorations.dart';

class AddTransactionAmountField extends StatelessWidget {
  const AddTransactionAmountField({
    required this.controller,
    required this.formatter,
    this.validator,
    super.key,
  });

  final TextEditingController controller;
  final CurrencyTextInputFormatter formatter;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      inputFormatters: [formatter],
      controller: controller,
      textAlign: TextAlign.center,
      decoration: Decorations.amountInputDecoration,
      keyboardType: TextInputType.number,
      style: const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 48,
      ),
    );
  }
}
