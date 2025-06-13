import 'package:flutter_test/flutter_test.dart';
import 'package:spending_pal/src/core/common/value_object/value_object.dart';

class TestValueObject extends SingleValueObject<String> {
  const TestValueObject(super.value);
}

void main() {
  group('ValueObject', () {
    setUp(() {});

    test('toString', () {
      expect(TestValueObject('test').toString(), 'SingleValueObject(value: test)');
    });
  });
}
