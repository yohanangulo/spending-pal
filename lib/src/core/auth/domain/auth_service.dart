import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {
  Stream<User?> getUser();
  Future<void> signOut();
  Future<UserCredential> signInWithEmailAndPassword(String email, String password);
}
