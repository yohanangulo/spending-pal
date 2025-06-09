part of 'sign_up_cubit.dart';

enum SignUpStatus { initial, loading, success, failure }

class SignUpState extends Equatable {
  const SignUpState({
    this.status = SignUpStatus.initial,
    this.email = const Email(''),
    this.password = const Password(''),
    this.confirmPassword = '',
  });

  final Email email;
  final Password password;
  final String confirmPassword;
  final SignUpStatus status;

  @override
  List<Object> get props => [email, password, confirmPassword, status];

  SignUpState copyWith({
    Email? email,
    Password? password,
    SignUpStatus? status,
    String? confirmPassword,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
    );
  }
}
