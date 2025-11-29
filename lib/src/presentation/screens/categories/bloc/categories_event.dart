part of 'categories_bloc.dart';

sealed class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object> get props => [];
}

class CategoriesSubscriptionRequested extends CategoriesEvent {}

class CategoriesCreateRequested extends CategoriesEvent {}

class CategoriesSetEditingCategory extends CategoriesEvent {
  const CategoriesSetEditingCategory({
    required this.category,
  });

  final Category category;
}

class CategoriesDeleteRequested extends CategoriesEvent {
  const CategoriesDeleteRequested({
    required this.id,
  });

  final String id;
}

class CategoriesIconChanged extends CategoriesEvent {
  const CategoriesIconChanged({
    required this.icon,
  });

  final CategoryIcon icon;
}

class CategoriesColorChanged extends CategoriesEvent {
  const CategoriesColorChanged({
    required this.color,
  });

  final CategoryColor color;
}

class CategoriesNameChanged extends CategoriesEvent {
  const CategoriesNameChanged({
    required this.name,
  });

  final String name;

  @override
  List<Object> get props => [name];
}

class CategoriesResetForm extends CategoriesEvent {}
