import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/service_locator/service_locator.dart';
import 'package:spending_pal/src/presentation/core/auth/auth_bloc.dart';

class GlobalBlocs extends StatelessWidget {
  const GlobalBlocs({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(lazy: false, create: (context) => getIt<AuthBloc>()..add(AuthSubscriptionRequested())),
      ],
      child: child,
    );
  }
}
