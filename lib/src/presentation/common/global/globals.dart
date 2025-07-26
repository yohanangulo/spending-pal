import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:spending_pal/src/presentation/common/global/global_blocs.dart';
import 'package:spending_pal/src/presentation/common/global/global_listeners.dart';

class Globals extends StatelessWidget {
  const Globals({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Nested(
      children: const [
        GlobalBlocs(),
        GlobalListeners(),
      ],
      child: child,
    );
  }
}
