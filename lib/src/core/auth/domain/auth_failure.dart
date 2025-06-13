sealed class AuthFailure {
  const AuthFailure();
  factory AuthFailure.unexpected() => const AuthFailureUnexpected();
  factory AuthFailure.invalidCredentials() => const AuthFailureInvalidCredentials();
  factory AuthFailure.tooManyRequests() => const AuthFailureTooManyRequests();
}

class AuthFailureUnexpected extends AuthFailure {
  const AuthFailureUnexpected();
}

class AuthFailureInvalidCredentials extends AuthFailure {
  const AuthFailureInvalidCredentials();
}

class AuthFailureTooManyRequests extends AuthFailure {
  const AuthFailureTooManyRequests();
}
