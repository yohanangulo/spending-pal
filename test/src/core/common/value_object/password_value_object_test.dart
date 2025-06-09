import 'package:flutter_test/flutter_test.dart';
import 'package:spending_pal/src/core/common/value_object/password_value_object.dart';

void main() {
  group('Password', () {
    test('isValid', () {
      expect(Password('123456').isValid, true);
    });

    test('toString', () {
      expect(Password('123456').toString(), 'Password(value: 123456)');
    });

    test('==', () {
      expect(Password('123456') == Password('123456'), true);
    });

    test('hashCode', () {
      expect(Password('123456').hashCode, Password('123456').hashCode);
    });
  });
}
