import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_failure.freezed.dart';

@freezed
class TransactionFailure with _$TransactionFailure {
  factory TransactionFailure.unexpected() = _Unexpected;
  factory TransactionFailure.notFound() = _NotFound;
  factory TransactionFailure.insufficientData() = _InsufficientData;
  factory TransactionFailure.syncError() = _SyncError;
}
