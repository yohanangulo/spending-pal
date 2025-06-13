import 'package:flutter_test/flutter_test.dart';
import 'package:spending_pal/src/core/auth/domain/auth_failure.dart';

void main() {
  group('AuthFailure', () {
    test('unexpected', () {
      expect(AuthFailure.unexpected(), isA<AuthFailureUnexpected>());
    });

    test('invalidCredentials', () {
      expect(AuthFailure.invalidCredentials(), isA<AuthFailureInvalidCredentials>());
    });

    test('tooManyRequests', () {
      expect(AuthFailure.tooManyRequests(), isA<AuthFailureTooManyRequests>());
    });
  });
}
