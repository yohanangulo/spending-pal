import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spending_pal/src/core/user/src/domain/user_failure.dart';

abstract class UserRepository {
  Stream<Option<User>> getUser();

  // TODO: these two methods should be replaced with updateUserProfile
  Future<Either<UserFailure, Unit>> updateUserDisplayName(String displayName);
  Future<Either<UserFailure, Unit>> updateUserProfileImage(File imageFile);
}
