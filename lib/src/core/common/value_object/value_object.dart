import 'package:flutter/material.dart';

@immutable
abstract class ValueObject {}

abstract class SingleValueObject<T extends Object> implements ValueObject {
  const SingleValueObject(this.value);

  final T value;

  @override
  String toString() {
    return 'SingleValueObject(value: $value)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SingleValueObject && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;
}
