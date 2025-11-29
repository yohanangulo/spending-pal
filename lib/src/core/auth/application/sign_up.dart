import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/auth/domain.dart';
import 'package:spending_pal/src/core/auth/domain/auth_failure.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:uuid/uuid.dart';

@injectable
class SignUp {
  SignUp(this._authRepository, this._categoryRepository);

  final AuthRepository _authRepository;
  final CategoryRepository _categoryRepository;
  final _uuid = const Uuid();

  Future<Either<AuthFailure, UserCredential>> call(String email, String password) async {
    final failureOrSuccess = await _authRepository.signUpWithEmailAndPassword(email, password);

    return failureOrSuccess.fold(
      (failure) async => left(failure),
      (userCredential) async {
        final initialCategories = Category.initialCategories(userCredential.user!.uid);

        await Future.wait([
          for (final category in initialCategories)
            _categoryRepository.createCategory(category.copyWith(id: _uuid.v4())),
        ]);

        return right(userCredential);
      },
    );
  }
}
