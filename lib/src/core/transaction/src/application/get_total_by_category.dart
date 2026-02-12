import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';

@injectable
class GetTotalByCategory {
  const GetTotalByCategory(this._repository);

  final TransactionRepository _repository;

  Future<Either<TransactionFailure, double>> call({
    required String categoryId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _repository.getTotalByCategory(
      categoryId: categoryId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
