import 'package:flutter/rendering.dart';

abstract class Corners {
  const Corners._();

  static BorderRadius get circular4 => BorderRadius.circular(4);
  static BorderRadius get circular8 => BorderRadius.circular(8);
  static BorderRadius get circular12 => BorderRadius.circular(12);
  static BorderRadius get circular16 => BorderRadius.circular(16);
  static BorderRadius get circular20 => BorderRadius.circular(20);
  static BorderRadius get circular28 => BorderRadius.circular(28);
  static BorderRadius get circular32 => BorderRadius.circular(32);
  static BorderRadius get circular48 => BorderRadius.circular(48);

  static BorderRadius get circularFull => BorderRadius.circular(999);

  static const radius4 = Radius.circular(4);
  static const radius8 = Radius.circular(8);
  static const radius12 = Radius.circular(12);
  static const radius16 = Radius.circular(16);
  static const radius20 = Radius.circular(20);
  static const radius28 = Radius.circular(28);
  static const radius32 = Radius.circular(32);
  static const radius48 = Radius.circular(48);
}
