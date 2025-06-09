import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spending_pal/src/core/auth/application.dart';
import 'package:spending_pal/src/core/auth/domain.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  group('GetAuthStatus', () {
    late MockAuthRepository mockAuthRepository;
    late GetAuthStatus getAuthStatus;
    late MockUser mockUser;

    setUp(() {
      mockUser = MockUser();
      mockAuthRepository = MockAuthRepository();
      getAuthStatus = GetAuthStatus(mockAuthRepository);
    });

    test('should return user when user is not null', () async {
      // arrange
      when(() => mockAuthRepository.getUser()).thenAnswer((_) => Stream.value(some(mockUser)));

      // act
      final result = getAuthStatus();

      // assert
      expect(result, isA<Stream<Option<User>>>());
      verify(() => mockAuthRepository.getUser()).called(1);
    });
  });
}
