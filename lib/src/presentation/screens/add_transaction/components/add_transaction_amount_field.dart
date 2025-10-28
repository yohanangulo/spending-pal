import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:spending_pal/src/presentation/common/resources/decorations.dart';

class AddTransactionAmountField extends StatelessWidget {
  const AddTransactionAmountField({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  static final _formatter = CurrencyTextInputFormatter.currency(
    symbol: r'$',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: [_formatter],
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
