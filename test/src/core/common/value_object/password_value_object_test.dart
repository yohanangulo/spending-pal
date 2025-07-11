import 'package:flutter_test/flutter_test.dart';
import 'package:spending_pal/src/core/common/value_object/password_value_object.dart';

void main() {
  group('Password', () {
    test('isValid', () {
      expect(const Password('123456').isValid, true);
    });

    test('toString', () {
      expect(const Password('123456').toString(), 'Password(value: 123456)');
    });

    test('==', () {
      expect(const Password('123456') == const Password('123456'), true);
    });

    test('hashCode', () {
      expect(const Password('123456').hashCode, const Password('123456').hashCode);
    });
  });
}
