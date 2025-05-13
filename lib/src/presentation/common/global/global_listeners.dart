import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/presentation/common/auth/auth_guard.dart';

class GlobalListeners extends StatelessWidget {
  const GlobalListeners({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        AuthGuard(),
      ],
      child: child,
    );
  }
}
