sealed class UserFailure {
  const UserFailure();
  factory UserFailure.unexpected() => const UserFailureUnexpected();
}

class UserFailureUnexpected extends UserFailure {
  const UserFailureUnexpected();
}
