import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spending_pal/src/core/auth/application.dart';
import 'package:spending_pal/src/core/auth/domain.dart';
import 'package:spending_pal/src/core/onboarding/domain.dart';
import 'package:spending_pal/src/presentation/core/auth/auth_bloc.dart';

class MockGetAuthStatus extends Mock implements GetAuthStatus {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

class MockUser extends Mock implements User {}

void main() {
  group('AuthBloc', () {
    late MockGetAuthStatus mockGetAuthStatus;
    late MockAuthRepository mockAuthRepository;
    late MockOnboardingRepository mockOnboardingRepository;
    late MockUser mockUser;

    setUp(() {
      mockGetAuthStatus = MockGetAuthStatus();
      mockAuthRepository = MockAuthRepository();
      mockOnboardingRepository = MockOnboardingRepository();
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
        mockOnboardingRepository,
      ),
      act: (bloc) => bloc.add(AuthSubscriptionRequested()),
      expect: () => [
        AuthState.authenticated(mockUser),
      ],
    );

    blocTest(
      'auth subscription requested when user is null and onboarding is not completed',
      setUp: () {
        when(() => mockGetAuthStatus()).thenAnswer((_) => Stream.value(none()));
        when(() => mockOnboardingRepository.isOnboardingCompleted).thenAnswer((_) => Future.value(false));
      },
      build: () => AuthBloc(
        mockGetAuthStatus,
        mockAuthRepository,
        mockOnboardingRepository,
      ),
      act: (bloc) => bloc.add(AuthSubscriptionRequested()),
      expect: () => [
        const AuthState.onboarding(),
      ],
    );

    blocTest(
      'auth subscription requested when user is null and onboarding is completed',
      setUp: () {
        when(() => mockGetAuthStatus()).thenAnswer((_) => Stream.value(none()));
        when(() => mockOnboardingRepository.isOnboardingCompleted).thenAnswer((_) => Future.value(true));
      },
      build: () => AuthBloc(
        mockGetAuthStatus,
        mockAuthRepository,
        mockOnboardingRepository,
      ),
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
      build: () => AuthBloc(mockGetAuthStatus, mockAuthRepository, mockOnboardingRepository),
      act: (bloc) => bloc.add(AuthLogoutRequested()),
      expect: () => [],
    );
  });
}
