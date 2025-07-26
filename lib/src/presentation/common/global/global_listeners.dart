import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:spending_pal/src/presentation/common/auth/auth_guard.dart';

class GlobalListeners extends SingleChildStatelessWidget {
  const GlobalListeners({super.key});

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return MultiBlocListener(
      listeners: [
        AuthGuard(),
      ],
      child: child!,
    );
  }
}
