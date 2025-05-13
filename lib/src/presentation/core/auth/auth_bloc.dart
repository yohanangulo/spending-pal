import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/auth/application.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._getAuthStatus) : super(const AuthState.unknown()) {
    on<AuthSubscriptionRequested>(_onAuthSubscriptionRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  final GetAuthStatus _getAuthStatus;

  Future<void> _onAuthSubscriptionRequested(
    AuthSubscriptionRequested event,
    Emitter<AuthState> emit,
  ) async {
    await emit.forEach(
      _getAuthStatus(),
      onData: (userOption) => userOption.fold(
        () => const AuthState.unauthenticated(),
        AuthState.authenticated,
      ),
    );
  }

  void _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) {}
}
