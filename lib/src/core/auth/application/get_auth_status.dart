import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/auth/domain.dart';

@injectable
class GetAuthStatus {
  const GetAuthStatus(this._authRepository);

  final AuthRepository _authRepository;

  Stream<Option<User>> call() {
    return _authRepository.getUser();
  }
}
