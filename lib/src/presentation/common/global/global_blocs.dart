import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:spending_pal/src/config/service_locator/service_locator.dart';
import 'package:spending_pal/src/core/common/blocs/theme_mode_cubit.dart';
import 'package:spending_pal/src/presentation/core/app_localizations_cubit/app_localizations_cubit.dart';
import 'package:spending_pal/src/presentation/core/auth/auth_bloc.dart';
import 'package:spending_pal/src/presentation/core/sync/sync_bloc.dart';

class GlobalBlocs extends SingleChildStatelessWidget {
  const GlobalBlocs({super.key});

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(lazy: false, create: (_) => getIt<AuthBloc>()..add(const AuthSubscriptionRequested())),
        BlocProvider(lazy: false, create: (_) => getIt<AppLocalizationsCubit>()),
        BlocProvider(lazy: false, create: (_) => getIt<ThemeModeCubit>()),
        BlocProvider(lazy: false, create: (_) => getIt<SyncBloc>()..add(SyncStarted())),
      ],
      child: child!,
    );
  }
}
