import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spending_pal/src/core/auth/application.dart';
import 'package:spending_pal/src/core/categories/application.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';

part 'categories_event.dart';
part 'categories_state.dart';

@injectable
class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc(
    this._getCurrentUser,
    this._categoryRepository,
    this._transactionRepository,
    this._createCategory,
    this._deleteCategory,
  ) : super(const CategoriesState()) {
    on<CategoriesSubscriptionRequested>(_onCategoriesSubscriptionRequested);
    on<CategoriesCreateRequested>(_onCategoriesCreateRequested);
    on<CategoriesNameChanged>(_onCategoriesNameChanged);
    on<CategoriesIconChanged>(_onCategoriesIconChanged);
    on<CategoriesColorChanged>(_onCategoriesColorChanged);
    on<CategoriesResetForm>(_onCategoriesResetForm);
    on<CategoriesDeleteRequested>(_onCategoriesDeleteRequested);
    on<CategoriesSetEditingCategory>(_onCategoriesSetEditingCategory);
  }

  final GetCurrentUser _getCurrentUser;
  final CategoryRepository _categoryRepository;
  final TransactionRepository _transactionRepository;
  final CreateCategory _createCategory;
  final DeleteCategory _deleteCategory;

  Category _updatedCategory() {
    return state.editingCategory!.copyWith(
      name: state.name!,
      icon: state.selectedIcon!,
      color: state.color!,
    );
  }

  Future<void> _onCategoriesSubscriptionRequested(
    CategoriesSubscriptionRequested event,
    Emitter<CategoriesState> emit,
  ) async {
    await emit.forEach(
      _getCurrentUser().switchMap((user) {
        final now = DateTime.now();
        final startOfMonth = DateTime(now.year, now.month);
        final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

        return Rx.combineLatest2(
          _categoryRepository.watchCategories(user!.uid),
          _transactionRepository.watchTransactionCountsByCategory(
            startDate: startOfMonth,
            endDate: endOfMonth,
          ),
          (List<Category> categories, Map<String, int> counts) {
            return categories
                .map(
                  (c) => c.copyWith(
                    transactionCount: counts[c.id] ?? 0,
                  ),
                )
                .toList();
          },
        );
      }),
      onData: (categories) => state.copyWith(categories: categories),
    );
  }

  Future<void> _onCategoriesCreateRequested(
    CategoriesCreateRequested event,
    Emitter<CategoriesState> emit,
  ) async {
    if (state.editingCategory == null) {
      final user = await _getCurrentUser().first;

      await _createCategory(
        name: state.name!,
        icon: state.selectedIcon!.codePoint,
        color: state.color!.value,
        userId: user!.uid,
      );
    } else {
      final updated = _updatedCategory();
      await _categoryRepository.updateCategory(updated);
    }
  }

  Future<void> _onCategoriesNameChanged(
    CategoriesNameChanged event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _onCategoriesIconChanged(
    CategoriesIconChanged event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(state.copyWith(selectedIcon: event.icon));
  }

  Future<void> _onCategoriesColorChanged(
    CategoriesColorChanged event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(state.copyWith(color: event.color));
  }

  Future<void> _onCategoriesResetForm(
    CategoriesResetForm event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(CategoriesState(categories: state.categories));
  }

  Future<void> _onCategoriesDeleteRequested(
    CategoriesDeleteRequested event,
    Emitter<CategoriesState> emit,
  ) async {
    await _deleteCategory(event.id);
  }

  Future<void> _onCategoriesSetEditingCategory(
    CategoriesSetEditingCategory event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(
      state.copyWith(
        editingCategory: event.category,
        name: event.category.name,
        selectedIcon: event.category.icon,
        color: event.category.color,
      ),
    );
  }
}
