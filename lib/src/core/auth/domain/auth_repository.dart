import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<Option<User>> getUser();
  Future<void> signOut();
  Future<UserCredential> signInWithEmailAndPassword(String email, String password);
}
