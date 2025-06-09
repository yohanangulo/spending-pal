part of 'sign_in_cubit.dart';

enum SignInStatus { initial, loading, success, failure }

final class SignInState extends Equatable {
  const SignInState({
    this.status = SignInStatus.initial,
    this.email = const Email(''),
    this.password = const Password(''),
    this.failure = const None(),
  });

  final SignInStatus status;
  final Email email;
  final Password password;
  final Option<AuthFailure> failure;

  @override
  List<Object> get props => [email, status, password, failure];

  SignInState copyWith({
    SignInStatus? status,
    Email? email,
    Password? password,
    Option<AuthFailure>? failure,
  }) {
    return SignInState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      failure: failure ?? this.failure,
    );
  }
}
