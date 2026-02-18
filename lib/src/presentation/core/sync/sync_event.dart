part of 'sync_bloc.dart';

@freezed
class SyncEvent with _$SyncEvent {
  factory SyncEvent.onStarted() = SyncStarted;
  factory SyncEvent.onSyncCategoriesRequested() = SyncCategoriesRequested;
  factory SyncEvent.onSyncTransactionsRequested() = SyncTransactionsRequested;
}
