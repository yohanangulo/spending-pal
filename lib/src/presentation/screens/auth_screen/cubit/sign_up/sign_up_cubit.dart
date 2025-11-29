import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/auth/application.dart';
import 'package:spending_pal/src/core/common/value_object/email_value_object.dart';
import 'package:spending_pal/src/core/common/value_object/password_value_object.dart';

part 'sign_up_state.dart';

@injectable
class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._signUp) : super(const SignUpState());

  final SignUp _signUp;

  void emailChanged(Email email) {
    emit(state.copyWith(email: email));
  }

  void passwordChanged(Password password) {
    emit(state.copyWith(password: password));
  }

  void confirmPasswordChanged(String confirmPassword) {
    emit(state.copyWith(confirmPassword: confirmPassword));
  }

  Future<void> signUpWithEmailAndPassword() async {
    emit(state.copyWith(status: SignUpStatus.loading));

    final result = await _signUp(state.email.value, state.password.value);

    result.fold(
      (failure) => emit(state.copyWith(status: SignUpStatus.failure)),
      (userCredential) => null,
    );
  }
}
