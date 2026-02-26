import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_total.freezed.dart';

@freezed
abstract class DailyTotal with _$DailyTotal {
  factory DailyTotal({
    required DateTime date,
    @Default(0) double income,
    @Default(0) double expense,
  }) = _DailyTotal;
}
