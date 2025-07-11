import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spending_pal/src/config/debug/logger/log.dart';
import 'package:spending_pal/src/core/storage/domain/storage_service.dart';
import 'package:spending_pal/src/core/user/domain.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(
    this._log,
    this._firebaseAuth,
    this._storageService,
  );

  final Log _log;
  final FirebaseAuth _firebaseAuth;
  final StorageService _storageService;
  final PublishSubject<Option<User>> _userSubject = PublishSubject<Option<User>>();

  @override
  Stream<Option<User>> getUser() => _userSubject.stream.asBroadcastStream();

  @override
  Future<Either<UserFailure, Unit>> updateUserDisplayName(String displayName) async {
    try {
      await _firebaseAuth.currentUser?.updateDisplayName(displayName);
      _userSubject.add(optionOf(_firebaseAuth.currentUser));
      return right(unit);
    } catch (e, s) {
      _log.e('Error updating user display name', e, s);

      return left(UserFailure.unexpected());
    }
  }

  @override
  Future<Either<UserFailure, Unit>> updateUserProfileImage(File imageFile) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return left(UserFailure.unexpected());
      }

      if (user.photoURL != null) {
        try {
          await _storageService.deleteProfileImage(user.photoURL!);
        } catch (e) {
          _log.w('Could not delete old profile image: $e');
        }
      }

      final photoUrl = await _storageService.uploadProfileImage(imageFile, user.uid);
      await user.updatePhotoURL(photoUrl);

      _userSubject.add(optionOf(_firebaseAuth.currentUser));

      return right(unit);
    } catch (e, s) {
      _log.e('Error updating user profile image', e, s);
      return left(UserFailure.unexpected());
    }
  }
}
