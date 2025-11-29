import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:uuid/uuid.dart';

@injectable
class CreateCategory {
  const CreateCategory(
    this._repository,
  );

  final CategoryRepository _repository;

  Future<void> call({
    required String name,
    required int icon,
    required int color,
    required String userId,
  }) async {
    final category = Category(
      id: const Uuid().v4(),
      userId: userId,
      name: name,
      icon: IconData(icon, fontFamily: 'MaterialIcons'),
      color: Color(color),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      expenseCount: 0,
    );

    await _repository.createCategory(category);
  }
}
