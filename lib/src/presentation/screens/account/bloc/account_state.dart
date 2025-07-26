part of 'account_bloc.dart';

class AccountState extends Equatable {
  const AccountState({
    this.user,
  });

  final User? user;

  @override
  List<Object?> get props => [user];

  AccountState copyWith({
    User? user,
  }) {
    return AccountState(
      user: user ?? this.user,
    );
  }
}
