import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/categories/domain.dart';

@injectable
class SyncCategories {
  SyncCategories(this._categoryRepository);

  final CategoryRepository _categoryRepository;

  Future<Either<CategoryFailure, Unit>> call() => _categoryRepository.sync();
}
