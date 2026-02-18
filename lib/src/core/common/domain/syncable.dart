import 'dart:async';

abstract interface class Syncable<T> {
  FutureOr<T> sync();
}
