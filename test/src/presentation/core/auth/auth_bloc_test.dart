import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spending_pal/src/core/auth/application.dart';
import 'package:spending_pal/src/core/auth/domain.dart';
import 'package:spending_pal/src/presentation/core/auth/auth_bloc.dart';

class MockGetAuthStatus extends Mock implements GetAuthStatus {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  group('AuthBloc', () {
    late MockGetAuthStatus mockGetAuthStatus;
    late MockAuthRepository mockAuthRepository;
    late MockUser mockUser;

    setUp(() {
      mockGetAuthStatus = MockGetAuthStatus();
      mockAuthRepository = MockAuthRepository();
      mockUser = MockUser();
    });

    blocTest(
      'auth subscription requested',
      setUp: () {
        when(() => mockGetAuthStatus()).thenAnswer((_) => Stream.value(some(mockUser)));
      },
      build: () => AuthBloc(
        mockGetAuthStatus,
        mockAuthRepository,
      ),
      act: (bloc) => bloc.add(AuthSubscriptionRequested()),
      expect: () => [
        AuthState.authenticated(mockUser),
      ],
    );

    blocTest(
      'auth subscription requested when user is null',
      setUp: () {
        when(() => mockGetAuthStatus()).thenAnswer((_) => Stream.value(none()));
      },
      build: () => AuthBloc(mockGetAuthStatus, mockAuthRepository),
      act: (bloc) => bloc.add(AuthSubscriptionRequested()),
      expect: () => [
        const AuthState.unauthenticated(),
      ],
    );

    blocTest(
      'auth logout requested',
      setUp: () {
        when(() => mockAuthRepository.signOut()).thenAnswer((_) async {});
      },
      build: () => AuthBloc(mockGetAuthStatus, mockAuthRepository),
      act: (bloc) => bloc.add(AuthLogoutRequested()),
      expect: () => [],
    );
  });
}
