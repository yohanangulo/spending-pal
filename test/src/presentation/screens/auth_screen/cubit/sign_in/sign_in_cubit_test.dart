import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spending_pal/src/core/auth/domain.dart';
import 'package:spending_pal/src/core/auth/domain/auth_failure.dart';
import 'package:spending_pal/src/core/common/value_object/email_value_object.dart';
import 'package:spending_pal/src/core/common/value_object/password_value_object.dart';
import 'package:spending_pal/src/presentation/screens/auth_screen/cubit/sign_in/sign_in_cubit.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  group('SignInCubit', () {
    late MockAuthRepository mockAuthRepository;
    late MockUserCredential mockUserCredential;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockUserCredential = MockUserCredential();
    });

    blocTest<SignInCubit, SignInState>(
      'email changed',
      build: () => SignInCubit(mockAuthRepository),
      act: (cubit) => cubit.emailChanged(Email('test@test.com')),
      expect: () => const <SignInState>[
        SignInState(email: Email('test@test.com')),
      ],
    );

    blocTest<SignInCubit, SignInState>(
      'password changed',
      build: () => SignInCubit(mockAuthRepository),
      act: (cubit) => cubit.passwordChanged(Password('password')),
      expect: () => const <SignInState>[
        SignInState(password: Password('password')),
      ],
    );

    blocTest<SignInCubit, SignInState>(
      'sign in with email and password',
      setUp: () {
        when(() => mockAuthRepository.signInWithEmailAndPassword(any(), any()))
            .thenAnswer((_) async => Right(mockUserCredential));
      },
      build: () => SignInCubit(mockAuthRepository),
      act: (cubit) => cubit.signInWithEmailAndPassword(),
      expect: () => <SignInState>[
        SignInState(
          status: SignInStatus.loading,
          failure: none(),
        ),
        SignInState(
          status: SignInStatus.success,
          failure: none(),
        ),
      ],
    );

    blocTest<SignInCubit, SignInState>(
      'sign in with email and password failure',
      setUp: () {
        when(() => mockAuthRepository.signInWithEmailAndPassword(any(), any()))
            .thenAnswer((_) async => left(AuthFailure.unexpected()));
      },
      build: () => SignInCubit(mockAuthRepository),
      act: (cubit) => cubit.signInWithEmailAndPassword(),
      expect: () => <SignInState>[
        SignInState(
          status: SignInStatus.loading,
          failure: none(),
        ),
        SignInState(
          status: SignInStatus.failure,
          failure: some(AuthFailure.unexpected()),
        ),
      ],
      verify: (_) {
        verify(() => mockAuthRepository.signInWithEmailAndPassword(any(), any())).called(1);
      },
    );

    blocTest(
      'clear failures',
      build: () => SignInCubit(mockAuthRepository),
      act: (cubit) => cubit.clearFailures(),
      expect: () => [
        SignInState(
          failure: none(),
        ),
      ],
    );
  });
}
