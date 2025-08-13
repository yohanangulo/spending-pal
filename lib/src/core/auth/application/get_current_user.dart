import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/auth/domain.dart';

@injectable
class GetCurrentUser {
  GetCurrentUser(this._authService);

  final AuthService _authService;

  Stream<User?> call() {
    return _authService.getUser();
  }
}
