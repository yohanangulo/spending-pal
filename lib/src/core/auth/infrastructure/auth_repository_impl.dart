import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/config/debug/logger/log.dart';
import 'package:spending_pal/src/core/auth/domain.dart';
import 'package:spending_pal/src/core/auth/domain/auth_failure.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._authService,
    this._log,
  );

  final AuthService _authService;
  final Log _log;

  @override
  Stream<Option<User>> getUser() => _authService.getUser().asyncMap(optionOf);

  @override
  Future<Either<AuthFailure, UserCredential>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _authService.signInWithEmailAndPassword(email, password);
      return right(userCredential);
    } catch (e, s) {
      _log.e('Error signing in with email and password', e, s);

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-login-credentials':
            return left(AuthFailure.invalidCredentials());
          case 'too-many-requests':
            return left(AuthFailure.tooManyRequests());
          case 'invalid-credential':
            return left(AuthFailure.invalidCredentials());
        }
        return left(AuthFailure.unexpected());
      }

      return left(AuthFailure.unexpected());
    }
  }

  @override
  Future<Either<AuthFailure, UserCredential>> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _authService.signUpWithEmailAndPassword(email, password);

      return right(userCredential);
    } catch (e, s) {
      _log.e('Error signing up with email and password', e, s);

      return left(AuthFailure.unexpected());
    }
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }
}
