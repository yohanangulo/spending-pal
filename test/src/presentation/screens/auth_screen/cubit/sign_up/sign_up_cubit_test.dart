import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spending_pal/src/core/auth/application.dart';
import 'package:spending_pal/src/core/auth/domain/auth_failure.dart';
import 'package:spending_pal/src/core/common/value_object/email_value_object.dart';
import 'package:spending_pal/src/core/common/value_object/password_value_object.dart';
import 'package:spending_pal/src/presentation/screens/auth_screen/cubit/sign_up/sign_up_cubit.dart';

class MockUserCredential extends Mock implements UserCredential {}

class MockSignUp extends Mock implements SignUp {}

void main() {
  group('SignUpCubit', () {
    late MockUserCredential mockUserCredential;
    late MockSignUp mockSignUp;

    setUp(() {
      mockUserCredential = MockUserCredential();
      mockSignUp = MockSignUp();
    });

    blocTest(
      'email changed',
      build: () => SignUpCubit(mockSignUp),
      act: (cubit) => cubit.emailChanged(const Email('test@test.com')),
      expect: () => [
        const SignUpState(email: Email('test@test.com')),
      ],
    );

    blocTest(
      'password changed',
      build: () => SignUpCubit(mockSignUp),
      act: (cubit) => cubit.passwordChanged(const Password('password')),
      expect: () => [
        const SignUpState(password: Password('password')),
      ],
    );

    blocTest(
      'confirm password changed',
      build: () => SignUpCubit(mockSignUp),
      act: (cubit) => cubit.confirmPasswordChanged('password'),
      expect: () => [
        const SignUpState(confirmPassword: 'password'),
      ],
    );

    blocTest(
      'sign up with email and password',
      setUp: () {
        when(
          () => mockSignUp(any(), any()),
        ).thenAnswer((_) async => Right(mockUserCredential));
      },
      build: () => SignUpCubit(mockSignUp),
      act: (cubit) => cubit.signUpWithEmailAndPassword(),
      expect: () => [
        const SignUpState(status: SignUpStatus.loading),
      ],
    );

    blocTest(
      'sign up with email and password failure',
      setUp: () {
        when(
          () => mockSignUp(any(), any()),
        ).thenAnswer((_) async => left(AuthFailure.unexpected()));
      },
      build: () => SignUpCubit(mockSignUp),
      act: (cubit) => cubit.signUpWithEmailAndPassword(),
      expect: () => [
        const SignUpState(status: SignUpStatus.loading),
        const SignUpState(status: SignUpStatus.failure),
      ],
    );
  });
}
