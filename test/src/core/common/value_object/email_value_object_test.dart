import 'package:flutter_test/flutter_test.dart';
import 'package:spending_pal/src/core/common/value_object/email_value_object.dart';

void main() {
  group('Email', () {
    test('isValid', () {
      expect(Email('test@test.com').isValid, true);
    });

    test('toString', () {
      expect(Email('test@test.com').toString(), 'Email(value: test@test.com)');
    });

    test('==', () {
      expect(Email('test@test.com') == Email('test@test.com'), true);
    });

    test('hashCode', () {
      expect(Email('test@test.com').hashCode, Email('test@test.com').hashCode);
    });
  });
}
