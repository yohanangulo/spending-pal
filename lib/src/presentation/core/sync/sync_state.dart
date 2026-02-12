part of 'sync_bloc.dart';

enum SyncCategoriesStatus { initial, syncing, success, failure }

@freezed
abstract class SyncState with _$SyncState {
  const factory SyncState({
    @Default(SyncCategoriesStatus.initial) SyncCategoriesStatus categoriesSyncStatus,
  }) = _SyncState;

  factory SyncState.initial() => const SyncState();
}
