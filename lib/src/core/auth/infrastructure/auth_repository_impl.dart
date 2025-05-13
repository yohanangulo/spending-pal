import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/auth/domain.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._authService);

  final AuthService _authService;

  @override
  Stream<Option<User>> getUser() => _authService.getUser().asyncMap(optionOf);

  @override
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) {
    return _authService.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }
}
