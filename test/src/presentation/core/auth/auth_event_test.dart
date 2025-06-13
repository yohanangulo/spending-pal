import 'package:flutter_test/flutter_test.dart';
import 'package:spending_pal/src/presentation/core/auth/auth_bloc.dart';

void main() {
  group('AuthEvent', () {
    test('props', () {
      expect(const AuthSubscriptionRequested().props, []);
      expect(const AuthLogoutRequested().props, []);
    });
  });
}
