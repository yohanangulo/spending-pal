import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/router/app_navigator.dart';
import 'package:spending_pal/src/presentation/core/auth/auth_bloc.dart';

class AuthGuard extends BlocListener<AuthBloc, AuthState> {
  AuthGuard({
    super.key,
  }) : super(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            switch (state.status) {
              case AuthStatus.unknown:
              case AuthStatus.unauthenticated:
                AppNavigator.navigateToLogin();
                break;
              case AuthStatus.authenticated:
                AppNavigator.navigateToDashboard();
                break;
              case AuthStatus.onboarding:
                AppNavigator.navigateToOnboarding();
                break;
            }
          },
        );
}
