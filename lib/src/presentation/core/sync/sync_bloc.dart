import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/auth/application.dart';
import 'package:spending_pal/src/core/categories/application.dart';

part 'sync_event.dart';
part 'sync_state.dart';
part 'sync_bloc.freezed.dart';

@injectable
class SyncBloc extends Bloc<SyncEvent, SyncState> {
  SyncBloc(
    this._watchAuthChanges,
    this._syncCategories,
  ) : super(SyncState.initial()) {
    on<SyncStarted>(_onStarted);
    on<SyncCategoriesRequested>(transformer: droppable(), _onSyncCategoriesRequested);
  }

  final WatchAuthChanges _watchAuthChanges;
  final SyncCategories _syncCategories;

  Future<void> _onStarted(
    SyncStarted event,
    Emitter<SyncState> emit,
  ) async {
    await emit.onEach(
      _watchAuthChanges(),
      onData: (data) => data.fold(
        () {},
        (_) {
          add(SyncCategoriesRequested());
        },
      ),
    );
  }

  Future<void> _onSyncCategoriesRequested(
    SyncCategoriesRequested event,
    Emitter<SyncState> emit,
  ) async {
    emit(state.copyWith(categoriesSyncStatus: SyncCategoriesStatus.syncing));

    final failureOrSuccess = await _syncCategories();

    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(categoriesSyncStatus: SyncCategoriesStatus.failure)),
      (_) => emit(state.copyWith(categoriesSyncStatus: SyncCategoriesStatus.success)),
    );
  }
}
