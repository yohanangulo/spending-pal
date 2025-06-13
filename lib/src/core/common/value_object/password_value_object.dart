import 'package:spending_pal/src/core/common/value_object/value_object.dart';

class Password extends SingleValueObject<String> {
  const Password(super.value);

  static const minLength = 6;

  bool get isValid => value.length >= minLength;

  @override
  String toString() {
    return 'Password(value: $value)';
  }
}
