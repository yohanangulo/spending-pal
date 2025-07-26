import 'package:flutter/material.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';

class PasswordInput extends StatefulWidget {
  const PasswordInput({
    required this.onChanged,
    this.label = 'Password',
    this.initialValue,
    this.validator,
    super.key,
  });

  final String label;
  final String? initialValue;
  final void Function(String value) onChanged;
  final String? Function(String? value)? validator;

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _hidePassword = true;

  Widget get _buildSuffixIcon {
    return Padding(
      padding: const EdgeInsets.only(right: Dimens.p2),
      child: IconButton(
        icon: _hidePassword ? const Text('View') : const Text('Hide'),
        onPressed: () {
          setState(() {
            _hidePassword = !_hidePassword;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: _buildSuffixIcon,
      ),
      autofillHints: [AutofillHints.password],
      obscureText: _hidePassword,
      initialValue: widget.initialValue,
      onChanged: widget.onChanged,
      validator: widget.validator,
    );
  }
}
