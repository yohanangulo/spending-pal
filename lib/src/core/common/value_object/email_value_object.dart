import 'package:spending_pal/src/core/common/value_object/value_object.dart';

class Email extends SingleValueObject<String> {
  const Email(super.value);

  static const emailRegex = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  bool get isValid => RegExp(emailRegex).hasMatch(value);

  @override
  String toString() {
    return 'Email(value: $value)';
  }
}
