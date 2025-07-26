import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/user/domain.dart';

part 'account_event.dart';
part 'account_state.dart';

@injectable
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc(
    this._userRepository,
  ) : super(const AccountState()) {
    on<AccountSubscriptionRequested>(_onAccountSubscriptionRequested);
  }

  final UserRepository _userRepository;

  Future<void> _onAccountSubscriptionRequested(
    AccountSubscriptionRequested event,
    Emitter<AccountState> emit,
  ) async {
    await emit.onEach(
      _userRepository.getUser(),
      onData: (user) => user.fold(
        () => emit(state),
        (user) => emit(state.copyWith(user: user)),
      ),
    );
  }
}
