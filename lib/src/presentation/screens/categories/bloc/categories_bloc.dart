import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spending_pal/src/core/auth/application.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/core/categories/infrastructure.dart';

part 'categories_event.dart';
part 'categories_state.dart';

@injectable
class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc(
    this._getCurrentUser,
    this._categoryRepository,
  ) : super(const CategoriesState()) {
    on<CategoriesSubscriptionRequested>(_onCategoriesSubscriptionRequested);
    on<CategoriesCreateRequested>(_onCategoriesCreateRequested);
    on<CategoriesNameChanged>(_onCategoriesNameChanged);
    on<CategoriesIconChanged>(_onCategoriesIconChanged);
    on<CategoriesColorChanged>(_onCategoriesColorChanged);
    on<CategoriesResetForm>(_onCategoriesResetForm);
    on<CategoriesDeleteRequested>(_onCategoriesDeleteRequested);
    on<CategoriesSetEditingCategory>(_onCategoriesSetEditingCategory);
    _categoryRepository.fetchCategories();
  }

  final GetCurrentUser _getCurrentUser;
  final CategoryRepository _categoryRepository;

  Future<CreateCategoryDto> _createCategoryDto() async {
    final user = await _getCurrentUser().first;
    return CreateCategoryDto(
      name: state.name!,
      icon: state.selectedIcon!.codePoint,
      color: state.color!.toARGB32(),
      userId: user!.uid,
    );
  }

  Future<Category> _updatedCategory() async {
    return state.editingCategory!.copyWith(
      name: state.name!,
      icon: IconData(state.selectedIcon!.codePoint),
      color: Color(state.color!.toARGB32()),
    );
  }

  Future<void> _onCategoriesSubscriptionRequested(
    CategoriesSubscriptionRequested event,
    Emitter<CategoriesState> emit,
  ) async {
    await emit.forEach(
      _getCurrentUser().switchMap(
        (user) => _categoryRepository.watchCategories(user!.uid),
      ),
      onData: (categories) => state.copyWith(categories: categories),
    );
  }

  Future<void> _onCategoriesCreateRequested(
    CategoriesCreateRequested event,
    Emitter<CategoriesState> emit,
  ) async {
    if (state.editingCategory == null) {
      final dto = await _createCategoryDto();
      await _categoryRepository.createCategory(dto);
    } else {
      final updateDto = await _updatedCategory();
      await _categoryRepository.updateCategory(updateDto);
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
    await _categoryRepository.deleteCategory(event.id);
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
