part of 'sync_bloc.dart';

enum SyncCategoriesStatus { initial, syncing, success, failure }

enum SyncTransactionsStatus { initial, syncing, success, failure }

@freezed
abstract class SyncState with _$SyncState {
  const factory SyncState({
    @Default(SyncCategoriesStatus.initial) SyncCategoriesStatus categoriesSyncStatus,
    @Default(SyncTransactionsStatus.initial) SyncTransactionsStatus transactionsSyncStatus,
  }) = _SyncState;

  factory SyncState.initial() => const SyncState();
}
