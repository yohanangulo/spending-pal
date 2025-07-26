import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/auth/application.dart';
import 'package:spending_pal/src/core/auth/domain.dart';
import 'package:spending_pal/src/core/onboarding/domain.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._getAuthStatus,
    this._authRepository,
    this._onboardingRepository,
  ) : super(const AuthState.unknown()) {
    on<AuthSubscriptionRequested>(_onAuthSubscriptionRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  final GetAuthStatus _getAuthStatus;
  final AuthRepository _authRepository;
  final OnboardingRepository _onboardingRepository;

  Future<void> _onAuthSubscriptionRequested(
    AuthSubscriptionRequested event,
    Emitter<AuthState> emit,
  ) async {
    await emit.onEach(
      _getAuthStatus(),
      onData: (userOption) => userOption.fold(
        () async {
          final bool onboardingCompleted = await _onboardingRepository.isOnboardingCompleted;

          if (onboardingCompleted) {
            return emit(const AuthState.unauthenticated());
          }

          emit(const AuthState.onboarding());
        },
        (user) => emit(AuthState.authenticated(user)),
      ),
    );
  }

  void _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    _authRepository.signOut();
  }
}
