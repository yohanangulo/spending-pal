import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/categories/domain.dart';

@injectable
class DeleteCategory {
  DeleteCategory(this._categoryRepository);

  final CategoryRepository _categoryRepository;

  Future<void> call(String id) => _categoryRepository.deleteCategory(id);
}
