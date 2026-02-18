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
    final now = DateTime.now();

    final category = Category(
      id: const Uuid().v4(),
      userId: userId,
      name: name,
      icon: CategoryIcon(codePoint: icon),
      color: CategoryColor(value: color),
      createdAt: now,
      updatedAt: now,
      transactionCount: 0,
    );

    await _repository.createCategory(category);
  }
}
