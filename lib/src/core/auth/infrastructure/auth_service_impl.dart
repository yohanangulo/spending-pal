import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/auth/domain.dart';

@Injectable(as: AuthService)
class AuthServiceImpl implements AuthService {
  const AuthServiceImpl(
    this._firebaseAuth,
  );

  final FirebaseAuth _firebaseAuth;

  @override
  Stream<User?> getUser() => _firebaseAuth.authStateChanges();

  @override
  Future<void> signOut() async => _firebaseAuth.signOut();

  @override
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }
}
