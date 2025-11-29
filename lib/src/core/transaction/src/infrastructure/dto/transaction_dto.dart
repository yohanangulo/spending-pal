import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_dto.freezed.dart';
part 'transaction_dto.g.dart';

@freezed
abstract class TransactionDto with _$TransactionDto {
  factory TransactionDto() = _TransactionDto;

  factory TransactionDto.fromJson(Map<String, dynamic> json) => _$TransactionDtoFromJson(json);
}
