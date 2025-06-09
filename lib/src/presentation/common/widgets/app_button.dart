import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.child,
    this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
    this.style,
    super.key,
  });

  final bool isLoading;
  final VoidCallback? onPressed;
  final Widget child;
  final bool isEnabled;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style,
      onPressed: isLoading || !isEnabled ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 19,
              width: 19,
              child: CircularProgressIndicator.adaptive(),
            )
          : child,
    );
  }
}
