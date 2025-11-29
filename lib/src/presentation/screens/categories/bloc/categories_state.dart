// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'categories_bloc.dart';

class CategoriesState extends Equatable {
  const CategoriesState({
    this.categories = const [],
    this.name,
    this.selectedIcon,
    this.color,
    this.editingCategory,
  });

  final List<Category> categories;
  final String? name;
  final CategoryIcon? selectedIcon;
  final CategoryColor? color;
  final Category? editingCategory;

  bool get isFormValid => name != null && selectedIcon != null && color != null && name!.length > 3;
  bool get nameAlreadyExists => categories.any((category) => category.name == name);

  String? get errorText {
    if (editingCategory == null) {
      if (categories.any((category) => category.name.toLowerCase() == name?.toLowerCase())) {
        return 'Category name already exists';
      }
    } else {
      if (nameAlreadyExists && name != editingCategory!.name) {
        return 'Category name already exists';
      }
    }
    return null;
  }

  @override
  List<Object?> get props => [categories, name, selectedIcon, color, editingCategory];

  CategoriesState copyWith({
    List<Category>? categories,
    String? name,
    CategoryIcon? selectedIcon,
    CategoryColor? color,
    bool? nameAlreadyExists,
    Category? editingCategory,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      name: name ?? this.name,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      color: color ?? this.color,
      editingCategory: editingCategory ?? this.editingCategory,
    );
  }
}
