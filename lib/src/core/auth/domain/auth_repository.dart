import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spending_pal/src/core/auth/domain/auth_failure.dart';

abstract class AuthRepository {
  Stream<Option<User>> watchAuthChanges();
  Stream<Option<User>> getUser();
  Future<void> signOut();
  Future<Either<AuthFailure, UserCredential>> signInWithEmailAndPassword(String email, String password);
  Future<Either<AuthFailure, UserCredential>> signUpWithEmailAndPassword(String email, String password);
}
