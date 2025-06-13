import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/auth/domain.dart';
import 'package:spending_pal/src/core/auth/domain/auth_failure.dart';
import 'package:spending_pal/src/core/common/value_object/email_value_object.dart';
import 'package:spending_pal/src/core/common/value_object/password_value_object.dart';

part 'sign_in_state.dart';

@injectable
class SignInCubit extends Cubit<SignInState> {
  SignInCubit(
    this._authRepository,
  ) : super(const SignInState());

  final AuthRepository _authRepository;

  Future<void> signInWithEmailAndPassword() async {
    emit(state.copyWith(
      status: SignInStatus.loading,
      failure: none(),
    ));

    final result = await _authRepository.signInWithEmailAndPassword(state.email.value, state.password.value);

    result.fold(
      (failure) => emit(state.copyWith(
        status: SignInStatus.failure,
        failure: some(failure),
      )),
      (userCredential) => emit(state.copyWith(
        status: SignInStatus.success,
        failure: none(),
      )),
    );
  }

  void emailChanged(Email email) {
    emit(state.copyWith(
      email: email,
    ));
  }

  void passwordChanged(Password password) {
    emit(state.copyWith(
      password: password,
    ));
  }
}
