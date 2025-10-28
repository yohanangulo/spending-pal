import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spending_pal/src/core/auth/domain.dart';
import 'package:spending_pal/src/core/auth/domain/auth_failure.dart';
import 'package:spending_pal/src/core/common/value_object/email_value_object.dart';
import 'package:spending_pal/src/core/common/value_object/password_value_object.dart';
import 'package:spending_pal/src/presentation/screens/auth_screen/cubit/sign_up/sign_up_cubit.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  group('SignUpCubit', () {
    late MockAuthRepository mockAuthRepository;
    late MockUserCredential mockUserCredential;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockUserCredential = MockUserCredential();
    });

    blocTest(
      'email changed',
      build: () => SignUpCubit(mockAuthRepository),
      act: (cubit) => cubit.emailChanged(const Email('test@test.com')),
      expect: () => [
        const SignUpState(email: Email('test@test.com')),
      ],
    );

    blocTest(
      'password changed',
      build: () => SignUpCubit(mockAuthRepository),
      act: (cubit) => cubit.passwordChanged(const Password('password')),
      expect: () => [
        const SignUpState(password: Password('password')),
      ],
    );

    blocTest(
      'confirm password changed',
      build: () => SignUpCubit(mockAuthRepository),
      act: (cubit) => cubit.confirmPasswordChanged('password'),
      expect: () => [
        const SignUpState(confirmPassword: 'password'),
      ],
    );

    blocTest(
      'sign up with email and password',
      setUp: () {
        when(
          () => mockAuthRepository.signUpWithEmailAndPassword(any(), any()),
        ).thenAnswer((_) async => Right(mockUserCredential));
      },
      build: () => SignUpCubit(mockAuthRepository),
      act: (cubit) => cubit.signUpWithEmailAndPassword(),
      expect: () => [
        const SignUpState(status: SignUpStatus.loading),
        const SignUpState(status: SignUpStatus.success),
      ],
    );

    blocTest(
      'sign up with email and password failure',
      setUp: () {
        when(
          () => mockAuthRepository.signUpWithEmailAndPassword(any(), any()),
        ).thenAnswer((_) async => left(AuthFailure.unexpected()));
      },
      build: () => SignUpCubit(mockAuthRepository),
      act: (cubit) => cubit.signUpWithEmailAndPassword(),
      expect: () => [
        const SignUpState(status: SignUpStatus.loading),
        const SignUpState(status: SignUpStatus.failure),
      ],
    );
  });
}
